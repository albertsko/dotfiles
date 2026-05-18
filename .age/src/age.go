package main

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

const encryptedDirSuffix = ".tar.gz.age"

// AgeVault stores validated age material and runs age helper scripts.
type AgeVault struct {
	identity   string
	recipient  string
	passphrase string

	identityScript    string
	recipientScript   string
	encryptFileScript string
	decryptFileScript string
	encryptDirScript  string
	decryptDirScript  string
}

// AgeVaultOption configures an AgeVault before validation.
type AgeVaultOption func(*AgeVault) error

// NewAgeVault creates an AgeVault from explicit script paths and options.
func NewAgeVault(
	identityScript,
	recipientScript,
	encryptFileScript,
	decryptFileScript,
	encryptDirScript,
	decryptDirScript string,
	opts ...AgeVaultOption,
) (*AgeVault, error) {
	vault := &AgeVault{
		identityScript:    identityScript,
		recipientScript:   recipientScript,
		encryptFileScript: encryptFileScript,
		decryptFileScript: decryptFileScript,
		encryptDirScript:  encryptDirScript,
		decryptDirScript:  decryptDirScript,
	}

	for _, opt := range opts {
		if opt == nil {
			return nil, fmt.Errorf("age vault option is nil")
		}

		err := opt(vault)
		if err != nil {
			return nil, err
		}
	}

	err := vault.verify()
	if err != nil {
		return nil, err
	}

	return vault, nil
}

// Encrypt encrypts a file or directory to outputPath.
func (vault *AgeVault) Encrypt(inputPath, outputPath string) error {
	if vault.recipient == "" {
		return fmt.Errorf("recipient is empty")
	}

	info, err := os.Stat(inputPath)
	if err != nil {
		return fmt.Errorf("failed to stat encrypt input path '%s': %w", inputPath, err)
	}

	if info.IsDir() && !isEncryptedDirPath(outputPath) {
		return fmt.Errorf("encrypted directory output path '%s' must end with %s", outputPath, encryptedDirSuffix)
	}

	if info.IsDir() {
		_, err := vault.runAgeScript(vault.encryptDirScript, vault.recipient, inputPath, outputPath)
		return err
	}

	if !info.Mode().IsRegular() {
		return fmt.Errorf("encrypt input path '%s' is not a regular file or directory", inputPath)
	}

	if isEncryptedDirPath(outputPath) {
		return fmt.Errorf("encrypted file output path '%s' must not end with %s", outputPath, encryptedDirSuffix)
	}

	_, err = vault.runAgeScript(vault.encryptFileScript, vault.recipient, inputPath, outputPath)
	return err
}

// Decrypt decrypts inputPath to outputPath.
// Paths ending in .tar.gz.age are treated as directory payloads.
func (vault *AgeVault) Decrypt(inputPath, outputPath string) error {
	if vault.identity == "" {
		return fmt.Errorf("identity is empty")
	}

	info, err := os.Stat(outputPath)
	if err != nil && !os.IsNotExist(err) {
		return fmt.Errorf("failed to stat decrypt output path '%s': %w", outputPath, err)
	}

	if isEncryptedDirPath(inputPath) {
		_, err := vault.runAgeScript(vault.decryptDirScript, vault.identity, inputPath, outputPath)
		return err
	}

	if err == nil && info.IsDir() {
		return fmt.Errorf("decrypt file output path '%s' is a directory", outputPath)
	}

	if err == nil && !info.Mode().IsRegular() {
		return fmt.Errorf("decrypt output path '%s' is not a regular file or directory", outputPath)
	}

	_, err = vault.runAgeScript(vault.decryptFileScript, vault.identity, inputPath, outputPath)
	return err
}

// isEncryptedDirPath follows the tar.gz.age convention used for directory payloads.
func isEncryptedDirPath(path string) bool {
	return strings.HasSuffix(path, encryptedDirSuffix)
}

// WithIdentityReader reads identity material from r.
func WithIdentityReader(r io.Reader) AgeVaultOption {
	return func(vault *AgeVault) error {
		identity, err := readAgeValue(r)
		if err != nil {
			return fmt.Errorf("failed to read identity: %w", err)
		}

		vault.identity = identity
		return nil
	}
}

// WithIdentityPassphrase sets the passphrase used by batchpass scripts.
func WithIdentityPassphrase(passphrase string) AgeVaultOption {
	return func(vault *AgeVault) error {
		vault.passphrase = passphrase
		return nil
	}
}

// WithIdentityPath reads identity material from path.
func WithIdentityPath(path string) AgeVaultOption {
	return func(vault *AgeVault) error {
		file, err := os.Open(path)
		if err != nil {
			return fmt.Errorf("failed to open identity path '%s': %w", path, err)
		}
		defer file.Close()

		return WithIdentityReader(file)(vault)
	}
}

// WithRecipientReader reads recipient material from r.
func WithRecipientReader(r io.Reader) AgeVaultOption {
	return func(vault *AgeVault) error {
		recipient, err := readAgeValue(r)
		if err != nil {
			return fmt.Errorf("failed to read recipient: %w", err)
		}

		vault.recipient = recipient
		return nil
	}
}

// WithRecipientPath reads recipient material from path.
func WithRecipientPath(path string) AgeVaultOption {
	return func(vault *AgeVault) error {
		file, err := os.Open(path)
		if err != nil {
			return fmt.Errorf("failed to open recipient path '%s': %w", path, err)
		}
		defer file.Close()

		return WithRecipientReader(file)(vault)
	}
}

// readAgeValue reads identity or recipient material into memory.
func readAgeValue(r io.Reader) (string, error) {
	if r == nil {
		return "", fmt.Errorf("reader is nil")
	}

	value, err := io.ReadAll(r)
	if err != nil {
		return "", err
	}

	return string(value), nil
}

// verify normalizes and validates configured identity and recipient material.
func (vault *AgeVault) verify() error {
	if vault.identity != "" {
		identity, err := vault.runAgeScript(vault.identityScript, vault.identity)
		if err != nil {
			return err
		}

		vault.identity = identity
	}

	if vault.recipient != "" {
		recipient, err := vault.runAgeScript(vault.recipientScript, vault.recipient)
		if err != nil {
			return err
		}

		vault.recipient = recipient
	}

	return nil
}

// runAgeScript executes one age helper script with secret input on stdin.
func (vault *AgeVault) runAgeScript(path, input string, args ...string) (string, error) {
	if path == "" {
		return "", fmt.Errorf("age script path is empty")
	}

	cmd := exec.Command("bash", append([]string{path}, args...)...)
	cmd.Stdin = strings.NewReader(input)
	cmd.Env = vault.ageScriptEnv(os.Environ())

	stdout := new(bytes.Buffer)
	stderr := new(bytes.Buffer)
	cmd.Stdout = stdout
	cmd.Stderr = stderr

	err := cmd.Run()
	if err != nil {
		name := filepath.Base(path)
		message := strings.TrimSpace(stderr.String())
		if message == "" {
			return "", fmt.Errorf("%s failed: %w", name, err)
		}

		return "", fmt.Errorf("%s failed: %s: %w", name, message, err)
	}

	return stdout.String(), nil
}

// ageScriptEnv prepares environment variables for age helper scripts.
func (vault *AgeVault) ageScriptEnv(environ []string) []string {
	env := make([]string, 0, len(environ)+1)

	for _, item := range environ {
		if strings.HasPrefix(item, "AGE_PASSPHRASE=") {
			continue
		}

		if strings.HasPrefix(item, "AGE_PASSPHRASE_FD=") {
			continue
		}

		env = append(env, item)
	}

	if vault.passphrase != "" {
		env = append(env, "AGE_PASSPHRASE="+vault.passphrase)
	}

	return env
}

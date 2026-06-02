package main

import (
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/albertsko/dotfiles/.age/src/age"
)

// init verifies the shell tools used by the vault are available.
func init() {
	required := []string{"git", "bash"}
	for _, req := range required {
		_, err := exec.LookPath(req)
		if err != nil {
			log.Fatalf("required bin %s is not installed or not in PATH\n", req)
		}
	}
}

const (
	secretsFile     = ".secrets"
	secretsLockFile = ".secrets.lock"
)

type options struct {
	commit bool
	push   bool
	pull   bool
	force  bool

	message string
}

func newVault(rootPath string) (*age.Vault, error) {
	return age.NewVault(
		rootPath,
		age.WithIdentityPassphrase([]byte("testowe haslo")),
		age.WithRecipientPath(filepath.Join(rootPath, ".age", "recipient.txt")),
		age.WithIdentityPath(filepath.Join(rootPath, ".age", "identity.age")),
	)
}

func main() {
	err := run(os.Args[1:])
	if err != nil {
		log.Fatalf("%+v", err)
	}
}

func run(args []string) error {
	opts := options{}
	fs := flag.NewFlagSet("dotfiles-age", flag.ContinueOnError)
	fs.SetOutput(io.Discard)
	fs.BoolVar(&opts.commit, "commit", false, "generate lock, encrypt changed secrets, and commit")
	fs.BoolVar(&opts.push, "push", false, "commit and push")
	fs.BoolVar(&opts.pull, "pull", false, "pull and decrypt secrets")
	fs.BoolVar(&opts.force, "force", false, "push with --force-with-lease")
	fs.StringVar(&opts.message, "m", "", "commit message")

	usage := func(w io.Writer) {
		fmt.Fprintln(w, "Usage:")
		fmt.Fprintln(w, "  dotfiles-age -commit [-m message]")
		fmt.Fprintln(w, "  dotfiles-age -push [-m message] [-force]")
		fmt.Fprintln(w, "  dotfiles-age -pull")
	}

	err := fs.Parse(args)
	if err != nil {
		usage(os.Stderr)
	}
	if err == flag.ErrHelp {
		return nil
	}
	if err != nil {
		return err
	}

	if !(opts.commit || opts.push || opts.pull) {
		usage(os.Stdout)
		return nil
	}

	if opts.pull && (opts.commit || opts.push) {
		return fmt.Errorf("-pull cannot be combined with -commit or -push")
	}

	if opts.force && !opts.push {
		return fmt.Errorf("-force requires -push")
	}

	rootPath := os.Getenv("DOTFILES_HOME")
	if rootPath == "" {
		return fmt.Errorf("DOTFILES_HOME not set")
	}

	if opts.pull {
		return pull(rootPath)
	}

	return commit(rootPath, opts)
}

func commit(rootPath string, opts options) error {
	secretsPath := filepath.Join(rootPath, secretsFile)
	secretsLockPath := filepath.Join(rootPath, secretsLockFile)

	secrets, err := NewSecrets(secretsPath, rootPath)
	if err != nil {
		return err
	}

	secretsRelPaths := secrets.SecretsRelPaths()

	oldSecretsLock, err := NewSecretsLockFromLockPath(secretsLockPath, rootPath)
	if err != nil {
		return err
	}

	newSecretsLock, err := NewSecretsLockFromSecrets(secretsLockPath, rootPath, secretsRelPaths)
	if err != nil {
		return err
	}

	changedSecrets := secretsToEncrypt(rootPath, secretsRelPaths, newSecretsLock.Diff(oldSecretsLock))
	v, err := newVault(rootPath)
	if err != nil {
		return err
	}

	for _, secret := range changedSecrets {
		_, err := v.Encrypt(filepath.Join(rootPath, secret))
		if err != nil {
			return fmt.Errorf("failed to encrypt secret '%s': %w", secret, err)
		}
	}

	err = newSecretsLock.Write()
	if err != nil {
		return err
	}

	defaultCommitMessage := func(changedSecrets []string) string {
		if len(changedSecrets) == 1 {
			return fmt.Sprintf("age: update %s", changedSecrets[0])
		}

		return fmt.Sprintf("age: update %d secrets", len(changedSecrets))
	}

	message := opts.message
	if message == "" {
		message = defaultCommitMessage(changedSecrets)
	}

	err = git(rootPath, "add", "-A")
	if err != nil {
		return err
	}

	err = git(rootPath, "commit", "-m", message)
	if err != nil {
		return err
	}

	if !opts.push {
		return nil
	}

	args := []string{"push"}
	if opts.force {
		args = append(args, "--force-with-lease")
	}

	return git(rootPath, args...)
}

func secretsToEncrypt(rootPath string, secretsRelPaths, changedSecrets []string) []string {
	seen := make(map[string]struct{}, len(secretsRelPaths))
	currentSecrets := make(map[string]struct{}, len(secretsRelPaths))
	secrets := make([]string, 0, len(secretsRelPaths))

	for _, secret := range secretsRelPaths {
		currentSecrets[secret] = struct{}{}
	}

	for _, secret := range changedSecrets {
		if _, ok := currentSecrets[secret]; !ok {
			continue
		}

		seen[secret] = struct{}{}
		secrets = append(secrets, secret)
	}

	encryptedSecretPath := func(rootPath, secret string) (string, error) {
		path := filepath.Join(rootPath, secret)
		info, err := os.Stat(path)
		if err != nil {
			return "", err
		}

		if info.IsDir() {
			return path + ".tar.gz.age", nil
		}

		return path + ".age", nil
	}

	for _, secret := range secretsRelPaths {
		if _, ok := seen[secret]; ok {
			continue
		}

		encrypted, err := encryptedSecretPath(rootPath, secret)
		if err != nil {
			continue
		}
		if fileExists(encrypted) {
			continue
		}

		secrets = append(secrets, secret)
	}

	return secrets
}

func pull(rootPath string) error {
	err := git(rootPath, "pull")
	if err != nil {
		return err
	}

	secrets, err := NewSecrets(filepath.Join(rootPath, secretsFile), rootPath)
	if err != nil {
		return err
	}

	v, err := newVault(rootPath)
	if err != nil {
		return err
	}

	decryptSecret := func(v *age.Vault, rootPath, secret string) error {
		path := filepath.Join(rootPath, secret)
		dirEncrypted := path + ".tar.gz.age"
		fileEncrypted := path + ".age"

		if fileExists(dirEncrypted) {
			err := os.RemoveAll(path)
			if err != nil {
				return err
			}

			_, err = v.Decrypt(dirEncrypted)
			return err
		}

		if fileExists(fileEncrypted) {
			_, err := v.Decrypt(fileEncrypted)
			return err
		}

		return fmt.Errorf("encrypted secret not found: %s", secret)
	}

	for _, secret := range secrets.SecretsRelPaths() {
		err := decryptSecret(v, rootPath, secret)
		if err != nil {
			return err
		}
	}

	return nil
}

func git(rootPath string, args ...string) error {
	cmd := exec.Command("git", args...)
	cmd.Dir = rootPath

	out, err := cmd.CombinedOutput()
	if len(out) > 0 {
		fmt.Print(string(out))
	}
	if err != nil {
		return fmt.Errorf("git %s failed: %w", strings.Join(args, " "), err)
	}

	return nil
}

func fileExists(path string) bool {
	_, err := os.Stat(path)
	return err == nil
}

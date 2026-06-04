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

	changedSecrets := oldSecretsLock.Diff(newSecretsLock)
	v, err := newVault(rootPath)
	if err != nil {
		return err
	}

	if len(changedSecrets) == 0 {
		return nil
	}

	toCommit := make([]string, 0, 1024)
	toCommit = append(toCommit, secretsLockFile)
	for _, secret := range changedSecrets {
		out, err := v.Encrypt(filepath.Join(rootPath, secret))
		if err != nil {
			return fmt.Errorf("failed to encrypt secret '%s': %w", secret, err)
		}

		outRel, err := filepath.Rel(rootPath, out)
		if err != nil {
			return err
		}
		toCommit = append(toCommit, outRel)
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

	err = git(rootPath, "restore", "--staged", ".")
	if err != nil {
		return fmt.Errorf("failed to restore --staged: %w", err)
	}

	for _, out := range toCommit {
		err = git(rootPath, "add", out)
		if err != nil {
			return fmt.Errorf("failed to git add: %w", err)
		}
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

func pull(rootPath string) error {
	err := git(rootPath, "pull", "--rebase")
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
		candidates := []string{
			filepath.Join(path, age.EncryptedDirSuffix),
			filepath.Join(path, age.EncryptedFileSuffix),
		}

		for _, candidate := range candidates {
			if fileExists(candidate) {
				_, err := v.Decrypt(candidate)
				if err != nil {
					return err
				}
			}
		}

		return nil
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

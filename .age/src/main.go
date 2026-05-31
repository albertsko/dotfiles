package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"

	"github.com/albertsko/dotfiles/.age/src/age"
)

const (
	secretsFile     = ".secrets"
	secretsLockFile = ".secrets.lock"
)

func main() {
	ctx, cancel := signal.NotifyContext(
		context.Background(),
		syscall.SIGTERM,
		syscall.SIGINT,
	)
	defer cancel()

	err := run()
	if err != nil {
		log.Fatalf("%+v", err)
	}

	<-ctx.Done()
}

func run() error {
	rootPath := os.Getenv("DOTFILES_HOME")
	if rootPath == "" {
		return fmt.Errorf("DOTFILES_HOME not set")
	}

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

	for _, secret := range newSecretsLock.Diff(oldSecretsLock) {
		fmt.Println(secret)
	}
	fmt.Println(secrets.Gitignore())

	v, err := age.NewVault(
		rootPath,
		age.WithIdentityPassphrase([]byte("testowe haslo")),
		age.WithRecipientPath(filepath.Join(rootPath, ".age", "recipient.txt")),
		age.WithIdentityPath(filepath.Join(rootPath, ".age", "identity.age")),
	)
	if err != nil {
		return err
	}

	v.Encrypt(filepath.Join(rootPath, ".gitignore"))

	return nil
	// return newSecretsLock.Write()
}

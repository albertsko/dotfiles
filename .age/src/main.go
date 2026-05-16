package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
)

const (
	secretsFile     = ".secrets"
	secretsLockFile = ".secrets.lock"
)

func main() {
	err := run()
	if err != nil {
		log.Fatalf("%+v", err)
	}
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

	return newSecretsLock.Write()
}

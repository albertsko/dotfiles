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

	ageScriptsDir         = ".age/src/scripts"
	identityToPlainScript = "identity-to-plain.sh"
	verifyRecipientScript = "verify-recipient.sh"
	encryptFileScript     = "encrypt-file.sh"
	decryptFileScript     = "decrypt-file.sh"
	encryptDirScript      = "encrypt-dir.sh"
	decryptDirScript      = "decrypt-dir.sh"
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

	vault, err := NewAgeVaultFromRoot(
		rootPath,
		WithIdentityPassphrase("testowe haslo"),
		WithRecipientPath(filepath.Join(rootPath, ".age", "recipient.txt")),
		WithIdentityPath(filepath.Join(rootPath, ".age", "identity.age")),
	)
	if err != nil {
		return err
	}

	vault.Encrypt(filepath.Join(rootPath, ".gitignore"), filepath.Join(rootPath, ".gitignore.age"))

	return nil
	// return newSecretsLock.Write()
}

func NewAgeVaultFromRoot(rootPath string, opts ...AgeVaultOption) (*AgeVault, error) {
	scriptsDir := filepath.Join(rootPath, ageScriptsDir)

	return NewAgeVault(
		filepath.Join(scriptsDir, identityToPlainScript),
		filepath.Join(scriptsDir, verifyRecipientScript),
		filepath.Join(scriptsDir, encryptFileScript),
		filepath.Join(scriptsDir, decryptFileScript),
		filepath.Join(scriptsDir, encryptDirScript),
		filepath.Join(scriptsDir, decryptDirScript),
		opts...,
	)
}

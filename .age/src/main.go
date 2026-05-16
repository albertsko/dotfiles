package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	err := run()
	if err != nil {
		log.Fatalf("%+v", err)
	}
}

func run() error {
	// determine root dir
	rootDir := os.Getenv("DOTFILES_HOME")
	if rootDir == "" {
		return fmt.Errorf("requirement: DOTFILES_HOME not set")
	}

	// open .secrets
	secretsPath := filepath.Join(rootDir, ".secrets")
	secrets, err := os.OpenFile(secretsPath, os.O_RDWR|os.O_CREATE, 0o644)
	if err != nil {
		return fmt.Errorf("fatal: %s failed to open: %w", secretsPath, err)
	}
	defer secrets.Close()

	// build gitignore
	gitignoreBuilder := new(strings.Builder)
	secretsRelPaths := make([]string, 0, 1024)

	scanner := bufio.NewScanner(secrets)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" {
			continue
		}

		gitignoreLine := buildOkGitignoreLine(rootDir, line)
		if gitignoreLine == "" {
			return fmt.Errorf("fatal: failed to build gitignore line for '%s'\nmake sure the path exists", line)
		}
		gitignoreBuilder.WriteString(gitignoreLine + "\n")
		secretsRelPaths = append(secretsRelPaths, line)
	}
	if err := scanner.Err(); err != nil {
		return fmt.Errorf("fatal: failed to scan %s: %w", secretsPath, err)
	}
	fmt.Println(gitignoreBuilder.String()) // TODO: remove

	// build .secrets.lock
	secretsLockPath := filepath.Join(rootDir, ".secrets.lock")
	oldSecretsLock, err := NewSecretsLockFromLockPath(secretsLockPath, rootDir)
	if err != nil {
		return err
	}

	newSecretsLock, err := NewSecretsLockFromSecrets(secretsLockPath, rootDir, secretsRelPaths)
	if err != nil {
		return err
	}

	for _, secret := range newSecretsLock.Diff(oldSecretsLock) {
		fmt.Println(secret)
	}

	return newSecretsLock.Write()
}

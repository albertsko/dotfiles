package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

func handleSecrets(rootDir string) error {
	// open .secrets
	secretsPath := filepath.Join(rootDir, secretsFile)
	secrets, err := os.OpenFile(secretsPath, os.O_RDWR|os.O_CREATE, 0o644)
	if err != nil {
		return fmt.Errorf("fatal: %s failed to open: %w", secretsPath, err)
	}
	defer secrets.Close()

	// build gitignore and prepare secretsRelPaths
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

	// build .secrets.lock
	secretsLockPath := filepath.Join(rootDir, secretsLockFile)
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

// buildOkGitignoreLine builds a .gitignore line for existing path
func buildOkGitignoreLine(root, sub string) string {
	full := filepath.Join(root, sub)
	info, err := os.Stat(full)
	if err != nil {
		return ""
	}

	relPath, err := filepath.Rel(root, full)
	if err != nil {
		return ""
	}

	gitPath := filepath.ToSlash(relPath)

	if !strings.HasPrefix(gitPath, "/") {
		gitPath = "/" + gitPath
	}

	if info.IsDir() {
		if !strings.HasSuffix(gitPath, "/") {
			gitPath += "/"
		}
	}

	return gitPath
}

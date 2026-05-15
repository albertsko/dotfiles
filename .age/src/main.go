package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	sl, _ := NewSecretsLock(nil)
	sl.Add("/Users/askonieczny/.local/share/dotfiles")

	// err := run()
	// if err != nil {
	// 	log.Fatalf("main err: %+v", err)
	// }
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

	scanner := bufio.NewScanner(secrets)
	for scanner.Scan() {
		line := scanner.Text()

		gitignoreLine := buildOkGitignoreLine(rootDir, line)
		if gitignoreLine == "" {
			return fmt.Errorf("fatal: failed to build gitignore line for '%s'\nmake sure the path exists", line)
		}
		gitignoreBuilder.WriteString(gitignoreLine + "\n")
	}
	fmt.Println(gitignoreBuilder.String()) // TODO: remove

	// seek to beginning of .secrets
	_, err = secrets.Seek(0, io.SeekStart)
	if err != nil {
		return fmt.Errorf("failed to seek to beginning: %+v", err)
	}

	// build .secrets.lock
	secretsLockPath := filepath.Join(rootDir, ".secrets.lock")
	secretsLock, err := os.OpenFile(secretsLockPath, os.O_RDWR|os.O_CREATE, 0o644)
	if err != nil {
		return fmt.Errorf("fatal: %s failed to open: %w", secretsLockPath, err)
	}
	defer secretsLock.Close()
	// secretsLockBuilder := new(strings.Builder)

	// w sumiw to co ja chcę robić na podstawie locka?
	// chcę sobie dowiedzieć się co się zmieniło co nie

	return nil
}

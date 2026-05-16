package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
)

type Secrets struct {
	secretsPath string
	rootPath    string

	secretsRelPaths []string
}

func NewSecrets(secretsPath, rootPath string) (*Secrets, error) {
	s := &Secrets{
		secretsPath: secretsPath,
		rootPath:    rootPath,
	}

	secretsFile, err := os.OpenFile(secretsPath, os.O_RDWR|os.O_CREATE, 0o644)
	if err != nil {
		return s, fmt.Errorf("failed to open '%s': %w", secretsPath, err)
	}
	defer secretsFile.Close()

	err = s.loadSecrets(secretsFile)
	if err != nil {
		return s, nil
	}

	return s, nil
}

func (s *Secrets) loadSecrets(r io.Reader) error {
	scanner := bufio.NewScanner(r)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		s.secretsRelPaths = append(s.secretsRelPaths, line)
	}

	if err := scanner.Err(); err != nil {
		return fmt.Errorf("failed to scan secrets file: %w", err)
	}

	return nil
}

func (s *Secrets) SecretsRelPaths() []string {
	return s.secretsRelPaths
}

func (s *Secrets) Gitignore() string {
	sb := new(strings.Builder)

	for _, secretRelPath := range s.secretsRelPaths {
		line, _ := buildGitignoreLine(s.rootPath, secretRelPath)
		sb.WriteString(line + "\n")
	}

	return sb.String()
}

func buildGitignoreLine(root, sub string) (line string, ok bool) {
	full := filepath.Join(root, sub)
	info, err := os.Stat(full)
	if err != nil {
		return "", false
	}

	relPath, err := filepath.Rel(root, full)
	if err != nil {
		return "", false
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

	return gitPath, true
}

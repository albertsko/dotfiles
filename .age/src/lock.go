package main

import (
	"bufio"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"io/fs"
	"maps"
	"os"
	"path/filepath"
	"strings"
	"sync"
)

const sha256HexLen = sha256.Size * 2

type (
	secret      map[string]string
	SecretsLock struct {
		lockPath string
		rootPath string

		secrets        secret
		secretsOrdered []string

		mu sync.Mutex
	}
)

// NewSecretsLockFromSecrets creates new SecretsLock from secretsRelPaths,
// takes rootPath, as root dir for relative secrets paths.
func NewSecretsLockFromSecrets(lockPath, rootPath string, secretsRelPaths []string) (*SecretsLock, error) {
	lock := &SecretsLock{
		lockPath:       lockPath,
		rootPath:       rootPath,
		secrets:        make(secret),
		secretsOrdered: make([]string, 0, 1024),
	}

	for _, secretRelPath := range secretsRelPaths {
		err := lock.Add(secretRelPath)
		if err != nil {
			return nil, fmt.Errorf("failed to add secret '%s': %w", secretRelPath, err)
		}
	}

	return lock, nil
}

// NewSecretsLockFromLockPath creates new SecretsLock from lockPath,
// takes rootPath, as root dir for relative secrets paths.
func NewSecretsLockFromLockPath(lockPath, rootPath string) (*SecretsLock, error) {
	lock := &SecretsLock{
		lockPath:       lockPath,
		rootPath:       rootPath,
		secrets:        make(secret),
		secretsOrdered: make([]string, 0, 1024),
	}

	secretsLock, err := os.OpenFile(lockPath, os.O_RDONLY|os.O_CREATE, 0o644)
	if err != nil {
		return nil, fmt.Errorf("failed to open lock file '%s': %w", lockPath, err)
	}
	defer secretsLock.Close()

	err = lock.loadSecretsLock(secretsLock)
	if err != nil {
		return nil, err
	}

	return lock, nil
}

func (ls *SecretsLock) loadSecretsLock(r io.Reader) error {
	if r == nil {
		return nil
	}

	ls.mu.Lock()
	defer ls.mu.Unlock()

	lineNo := 0

	s := bufio.NewScanner(r)
	for s.Scan() {
		lineNo++
		line := s.Text()

		secret, hash, err := parseSecretsLockLine(line)
		if err != nil {
			return fmt.Errorf("failed to parse lock file line %d: %w", lineNo, err)
		}

		_, ok := ls.secrets[secret]
		if !ok {
			ls.secrets[secret] = hash
			ls.secretsOrdered = append(ls.secretsOrdered, secret)
		}
	}

	if err := s.Err(); err != nil {
		return fmt.Errorf("failed to scan lock file: %w", err)
	}

	return nil
}

// Add records the current hash for a secret path.
func (sl *SecretsLock) Add(path string) error {
	sl.mu.Lock()
	defer sl.mu.Unlock()

	fullPath := filepath.Join(sl.rootPath, path)

	info, err := os.Stat(fullPath)
	if err != nil {
		return fmt.Errorf("failed to os.Stat path '%s': %w", fullPath, err)
	}

	var hash string
	if info.IsDir() {
		hash, err = hashDirState(fullPath)
		if err != nil {
			return err
		}
	}

	if !info.IsDir() {
		hash, err = hashFile(fullPath)
		if err != nil {
			return err
		}
	}

	if _, ok := sl.secrets[path]; !ok {
		sl.secretsOrdered = append(sl.secretsOrdered, path)
	}
	sl.secrets[path] = hash

	return nil
}

// Diff returns secret names whose hashes differ from another lock.
func (sl *SecretsLock) Diff(other *SecretsLock) []string {
	secretsOrdered, secrets := sl.snapshot()

	if other == nil {
		return secretsOrdered
	}

	otherSecretsOrdered, otherSecrets := other.snapshot()
	diff := make([]string, 0)
	seen := make(map[string]struct{}, len(secrets)+len(otherSecrets))

	for _, name := range secretsOrdered {
		seen[name] = struct{}{}

		if secrets[name] == otherSecrets[name] {
			continue
		}

		diff = append(diff, name)
	}

	for _, name := range otherSecretsOrdered {
		if _, ok := seen[name]; ok {
			continue
		}

		diff = append(diff, name)
	}

	return diff
}

// String formats the lock file contents.
func (sl *SecretsLock) String() string {
	sl.mu.Lock()
	defer sl.mu.Unlock()

	return sl.string()
}

func (sl *SecretsLock) string() string {
	b := new(strings.Builder)

	for _, name := range sl.secretsOrdered {
		hash, ok := sl.secrets[name]
		if !ok {
			continue
		}

		b.WriteString(name)
		b.WriteByte('\t')
		b.WriteString(hash)
		b.WriteByte('\n')
	}

	return b.String()
}

// Write writes the lock file contents to lockPath.
func (sl *SecretsLock) Write() error {
	sl.mu.Lock()
	defer sl.mu.Unlock()

	if sl.lockPath == "" {
		return fmt.Errorf("secrets lock path is empty")
	}

	return os.WriteFile(sl.lockPath, []byte(sl.string()), 0o644)
}

func (sl *SecretsLock) snapshot() ([]string, secret) {
	sl.mu.Lock()
	defer sl.mu.Unlock()

	secretsOrdered := append([]string(nil), sl.secretsOrdered...)
	secrets := make(secret, len(sl.secrets))
	maps.Copy(secrets, sl.secrets)

	return secretsOrdered, secrets
}

// parseSecretsLockLine parses one lock file line.
func parseSecretsLockLine(line string) (secret, hash string, err error) {
	errstr := "failed to parse secrets lock line"

	line = strings.TrimSpace(line)
	split := strings.Split(line, "\t")

	if len(split) != 2 {
		return "", "", fmt.Errorf("%s: split is not len 2", errstr)
	}

	if len(split[1]) != sha256HexLen {
		return "", "", fmt.Errorf("%s: hash is not len %d", errstr, sha256HexLen)
	}

	return split[0], split[1], nil
}

// hashFile generates a SHA256 hash from file contents.
func hashFile(path string) (string, error) {
	file, err := os.Open(path)
	if err != nil {
		return "", err
	}
	defer file.Close()

	h := sha256.New()
	_, err = io.Copy(h, file)
	if err != nil {
		return "", err
	}

	return hex.EncodeToString(h.Sum(nil)), nil
}

// hashDirState walks a dir and generates a SHA256 hash based on the
// metadata of all files within it.
func hashDirState(rootPath string) (string, error) {
	h := sha256.New()

	err := filepath.WalkDir(rootPath, func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			return nil
		}

		info, err := d.Info()
		if err != nil {
			return err
		}

		relPath, err := filepath.Rel(rootPath, path)
		if err != nil {
			return err
		}

		fileState := fmt.Sprintf("%s|%d|%o|%d",
			relPath,
			info.Size(),
			info.Mode(),
			info.ModTime().UnixNano(),
		)

		h.Write([]byte(fileState))

		return nil
	})
	if err != nil {
		return "", err
	}

	return hex.EncodeToString(h.Sum(nil)), nil
}

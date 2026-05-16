package main

import (
	"bufio"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"io/fs"
	"log"
	"os"
	"path/filepath"
	"strings"
)

const sha256HexLen = sha256.Size * 2

type (
	secret      map[string]string
	SecretsLock struct {
		secrets        secret
		secretsOrdered []string
		writer         io.WriteCloser
	}
)

// NewSecretsLock parses a lock file reader into a SecretsLock.
func NewSecretsLock(secretsReader io.Reader, lockWriter io.WriteCloser) (*SecretsLock, error) {
	lock := &SecretsLock{
		secrets:        make(secret),
		secretsOrdered: make([]string, 0, 1024),
		writer:         lockWriter,
	}

	if secretsReader == nil {
		return lock, nil
	}

	s := bufio.NewScanner(secretsReader)
	for s.Scan() {
		line := s.Text()

		secret, hash, err := parseSecretsLockLine(line)
		if err != nil {
			log.Println()
			continue
		}

		lock.secrets[secret] = hash
		lock.secretsOrdered = append(lock.secretsOrdered, secret)
	}

	return lock, nil
}

// Add records the current hash for a secret path.
func (sl *SecretsLock) Add(name, path string) error {
	info, err := os.Stat(path)
	if err != nil {
		return fmt.Errorf("failed to os.Stat path '%s': %w", path, err)
	}

	if info.IsDir() {
		hash, err := hashDirState(path)
		if err != nil {
			return err
		}
		if _, ok := sl.secrets[name]; !ok {
			sl.secretsOrdered = append(sl.secretsOrdered, name)
		}
		sl.secrets[name] = hash
		return nil
	}

	hash, err := hashFile(path)
	if err != nil {
		return err
	}
	if _, ok := sl.secrets[name]; !ok {
		sl.secretsOrdered = append(sl.secretsOrdered, name)
	}
	sl.secrets[name] = hash

	return nil
}

// Diff returns secret names whose hashes differ from another lock.
func (sl *SecretsLock) Diff(other *SecretsLock) []string {
	if other == nil {
		return append([]string(nil), sl.secretsOrdered...)
	}

	diff := make([]string, 0)
	seen := make(map[string]struct{}, len(sl.secrets)+len(other.secrets))

	for _, name := range sl.secretsOrdered {
		seen[name] = struct{}{}

		if sl.secrets[name] == other.secrets[name] {
			continue
		}

		diff = append(diff, name)
	}

	for _, name := range other.secretsOrdered {
		if _, ok := seen[name]; ok {
			continue
		}

		diff = append(diff, name)
	}

	return diff
}

// String formats the lock file contents.
func (sl *SecretsLock) String() string {
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

// Write writes the lock contents to the lock writer.
func (sl *SecretsLock) Write() error {
	if sl.writer == nil {
		return fmt.Errorf("secrets lock writer is nil")
	}

	_, err := io.WriteString(sl.writer, sl.String())
	return err
}

// Close closes the lock writer.
func (sl *SecretsLock) Close() error {
	if sl.writer == nil {
		return nil
	}

	return sl.writer.Close()
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

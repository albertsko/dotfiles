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

type (
	secret      map[string]string
	SecretsLock struct {
		secrets        secret
		secretsOrdered []string
	}
)

func NewSecretsLock(r io.Reader) (SecretsLock, error) {
	lock := SecretsLock{
		secrets:        make(secret),
		secretsOrdered: make([]string, 0, 1024),
	}

	if r == nil {
		return lock, nil
	}

	s := bufio.NewScanner(r)
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

// TODO
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
		sl.secrets[name] = hash
		fmt.Printf("%#v", sl.secrets)
		return nil
	}

	return nil
}

// TODO
func (sl *SecretsLock) Diff() []string {
	return []string{}
}

// TODO
func (sl *SecretsLock) String() string {
	return ""
}

func parseSecretsLockLine(line string) (secret, hash string, err error) {
	errstr := "failed to parse secrets lock line"

	line = strings.TrimSpace(line)
	split := strings.Split(line, "\t")

	if len(split) != 2 {
		return "", "", fmt.Errorf("%s: split is not len 2", errstr)
	}

	if len(split[1]) != 256 {
		return "", "", fmt.Errorf("%s: hash is not len 256", errstr)
	}

	return split[0], split[1], nil
}

// TODO: hashFile

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

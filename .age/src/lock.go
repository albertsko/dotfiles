package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
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
			return lock, err
		}

		lock.secrets[secret] = hash
		lock.secretsOrdered = append(lock.secretsOrdered, secret)
	}

	return lock, nil
}

// TODO
func (sl *SecretsLock) Add(path string) error {
	info, err := os.Stat(path)
	if err != nil {
		return fmt.Errorf("")
	}

	if info.IsDir() {
		fmt.Printf("%#v", info)
	}
	return nil
}

// TODO
func (sl *SecretsLock) Diff() []string {
	return []string{}
}

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

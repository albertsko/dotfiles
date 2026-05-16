package main

import (
	"fmt"
	"log"
	"os"
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
	// determine root dir
	rootDir := os.Getenv("DOTFILES_HOME")
	if rootDir == "" {
		return fmt.Errorf("requirement: DOTFILES_HOME not set")
	}

	return handleSecrets(rootDir)
}

package main

import (
	"fmt"
	"os"
	"path/filepath"
	"time"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(os.Stderr, "entrypoint: %v\n", err)
		os.Exit(1)
	}
}

func run() error {
	homePath, err := os.UserHomeDir()
	if err != nil {
		return fmt.Errorf("get home path: %w", err)
	}

	statePath := filepath.Join(homePath, ".local", "state", "entrypoint")
	if err := os.MkdirAll(statePath, 0o700); err != nil {
		return fmt.Errorf("create state path: %w", err)
	}

	logPath := filepath.Join(statePath, "entrypoint.log")
	logFile, err := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0o600)
	if err != nil {
		return fmt.Errorf("open log file: %w", err)
	}

	_, err = fmt.Fprintf(logFile, "%s entrypoint ran\n", time.Now().Format(time.RFC3339))
	closeErr := logFile.Close()

	if err != nil {
		return fmt.Errorf("write log entry: %w", err)
	}

	if closeErr != nil {
		return fmt.Errorf("close log file: %w", closeErr)
	}

	return nil
}

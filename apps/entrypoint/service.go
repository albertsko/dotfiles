package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
	"sync"
)

const (
	EntrypointDir     = "entrypoint"
	EntrypointLogFile = "entrypoint.log"
)

type Service struct {
	Path string
	L    *log.Logger
}

func NewService() (*Service, error) {
	// --- path ---
	homePath, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed getting home path: %w", err)
	}

	stateRoot := os.Getenv("XDG_STATE_HOME")
	if stateRoot == "" {
		stateRoot = filepath.Join(homePath, ".local", "state")
	}

	entrypointPath := filepath.Join(stateRoot, EntrypointDir)
	if err := os.MkdirAll(entrypointPath, 0o700); err != nil {
		return nil, fmt.Errorf("failed creating path: %w", err)
	}

	// --- logger ---
	logWriter := &LogWriter{logFile: filepath.Join(entrypointPath, EntrypointLogFile)}
	logger := log.New(logWriter, "", log.Ldate|log.Ltime|log.LUTC)

	return &Service{
		Path: entrypointPath,
		L:    logger,
	}, nil
}

type LogWriter struct {
	logFile        string
	loggedFilePath sync.Once
}

func (w *LogWriter) Write(p []byte) (n int, err error) {
	var errLogFilePath error
	logFilePath := func() {
		absPath, err := filepath.Abs(w.logFile)
		errLogFilePath = err
		fmt.Printf("\n\nlog file: %s\n", absPath)
	}

	w.loggedFilePath.Do(logFilePath)
	if errLogFilePath != nil {
		return 0, fmt.Errorf("failed to log file path: %w", err)
	}

	f, err := os.OpenFile(w.logFile, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0o600)
	if err != nil {
		return 0, err
	}
	defer func() {
		_ = f.Close()
	}()

	return f.Write(p)
}

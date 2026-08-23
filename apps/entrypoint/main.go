package main

import (
	"bytes"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(os.Stderr, "entrypoint: %v\n", err)
		os.Exit(1)
	}
}

func run() error {
	s, err := NewService()
	if err != nil {
		return fmt.Errorf("failed to create service: %w", err)
	}

	err = s.startContainerEngine()
	if err != nil {
		return err
	}

	err = s.runGDrive()
	if err != nil {
		return err
	}

	return nil
}

// --- service runners ---

func (s *Service) startContainerEngine() error {
	if runtime.GOOS == "darwin" {
		return s.runPodman()
	}

	return nil
}

func (s *Service) runPodman() error {
	err := execCmd("podman", "machine", "start")
	if err != nil && !strings.Contains(err.Error(), "already running") {
		return err
	}
	return nil
}

func (s *Service) runGDrive() error {
	dotfilesHome := os.Getenv("DOTFILES_HOME")
	if dotfilesHome == "" {
		return fmt.Errorf("DOTFILES_HOME is not set")
	}

	return execCmd(filepath.Join(dotfilesHome, "apps", "gdrive", "gdrive.sh"))
}

// --- helpers ---

func execCmd(args ...string) error {
	if len(args) == 0 {
		return fmt.Errorf("failed to execCmd: 0 len cmd")
	}

	cmd := exec.Command(args[0], args[1:]...)
	var stdout bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	err := cmd.Run()
	if err != nil {
		if exitErr, ok := errors.AsType[*exec.ExitError](err); ok {
			return fmt.Errorf("exit code %d\nstderr:\n%s", exitErr.ExitCode(), stderr.String())
		}

		return fmt.Errorf("failed to execute command: %+v", err)
	}
	return nil
}

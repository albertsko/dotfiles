package main

import (
	"fmt"
	"os"
	"path/filepath"
)

// what do we want?
// rclone check and rclone version check we don't want version less than 1.75
// we want an app struct that has all the paths and maybe logger?

// also what is our CLI design it is based on flags with go's std lib and what we want to do here?
// we want to either -service or -config

const (
	dataDir = "gdrive"
	bakDir  = "gdrive-bak"
)

type App struct {
	Path string
}

func NewApp() (*App, error) {
	newAppErr := func(err error) error {
		return fmt.Errorf("failed to create a new app: %w", err)
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return nil, newAppErr(err)
	}

	data := filepath.Join(home, dataDir)
	bak := filepath.Join(home, bakDir)

	os.MkdirAll()
}

func main() {
}

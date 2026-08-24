package main

import (
	"fmt"
	"os"
	"path/filepath"
)

const (
	dataDir = "gdrive"
	bakDir  = "gdrive-bak"
)

type Rclone struct {
	dataPath string
	bakPath  string
}

func NewRclone() (*Rclone, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("failed to create a new app: %w", err)
	}

	data := filepath.Join(home, dataDir)
	bak := filepath.Join(home, bakDir)

	err = os.MkdirAll(data, 0o700)
	if err != nil {
		return nil, fmt.Errorf("failed to mkdir data: %w", err)
	}

	err = os.MkdirAll(bak, 0o700)
	if err != nil {
		return nil, fmt.Errorf("failed to mkdir bak: %w", err)
	}

	return &Rclone{
		dataPath: data,
		bakPath:  bak,
	}, nil
}

package rclonebisync

import (
	"embed"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
)

//go:embed configs/filters.conf
var filtersConf embed.FS

const (
	accessCheckFile  = "RCLONE_TEST"
	defaultDataDir   = "rclone"
	defaultBackupDir = "rclone-bak"
)

type Bisync struct {
	o *options
}

type options struct {
	remotePath          string
	syncIntervalSeconds int
	dataPath            string
	backupPath          string
	configPath          string
	workdirPath         string
	filtersPath         *string
}

type Option func(opts *options) error

func New(
	remotePath string,
	syncIntervalSeconds int,
	opts ...Option,
) (*Bisync, error) {
	options := new(options)
	options.remotePath = remotePath
	options.syncIntervalSeconds = syncIntervalSeconds

	// defaults
	home := homeDir()
	remoteState := localStateDir(remotePath)

	options.dataPath = filepath.Join(home, defaultDataDir)
	options.backupPath = filepath.Join(home, defaultBackupDir)
	options.configPath = filepath.Join(remoteState, "config")
	options.workdirPath = filepath.Join(remoteState, "workdir")

	// opts
	for i, opt := range opts {
		err := opt(options)
		if err != nil {
			return nil, fmt.Errorf("failed to set opt [%d]: %w", i, err)
		}
	}

	_ = os.MkdirAll(options.dataPath, 0o700)
	_ = os.MkdirAll(options.backupPath, 0o700)
	_ = os.MkdirAll(options.configPath, 0o700)
	_ = os.MkdirAll(options.workdirPath, 0o700)

	// FS
	if options.filtersPath == nil {
		b, err := filtersConf.ReadFile("configs/filters.conf")
		if err != nil {
			return nil, fmt.Errorf("failed to load filters conf: %w", err)
		}
		path := filepath.Join(options.configPath, "filters.conf")
		err = os.WriteFile(path, b, 0o600)
		if err != nil {
			return nil, fmt.Errorf("failed to write filters conf: %w", err)
		}
	}

	return &Bisync{
		o: options,
	}, nil
}

func WithDataPath(path string) Option {
	return func(opts *options) error {
		opts.dataPath = path
		return nil
	}
}

func WithBackupPath(path string) Option {
	return func(opts *options) error {
		opts.backupPath = path
		return nil
	}
}

func WithConfigPath(path string) Option {
	return func(opts *options) error {
		opts.configPath = path
		return nil
	}
}

func WithWorkdirPath(path string) Option {
	return func(opts *options) error {
		opts.workdirPath = path
		return nil
	}
}

func WithFiltersPath(path string) Option {
	return func(opts *options) error {
		opts.filtersPath = &path
		return nil
	}
}

func homeDir() string {
	path, err := os.UserHomeDir()
	if err != nil {
		log.Fatalf("failed to get user home dir: %+v", err)
	}
	return path
}

func localStateDir(rcloneRemotePath string) string {
	home := homeDir()
	localState := filepath.Join(home, ".local", "state")
	_ = os.MkdirAll(localState, 0o700)

	path := filepath.Join(localState, "rclone", cutRemote(rcloneRemotePath))
	return path
}

func cutRemote(rcloneRemotePath string) string {
	cut, _, _ := strings.Cut(rcloneRemotePath, ":")
	return cut
}

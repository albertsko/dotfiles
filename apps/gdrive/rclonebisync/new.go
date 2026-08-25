package rclonebisync

import (
	"embed"
	"errors"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"
)

//go:embed configs/filters.conf
var filtersConf embed.FS

const (
	accessCheckFile  = "RCLONE_TEST"
	defaultDataDir   = "rclone"
	defaultBackupDir = "rclone-bak"
)

const (
	RcloneGeMajorVersion = 1
	RcloneGeMinorVersion = 75
)

type Bisync struct {
	o      *options
	runner rcloneRunner
}

type options struct {
	remotePath          string
	syncIntervalSeconds int
	dataPath            string
	backupPath          string
	configPath          string
	workdirPath         string
	filtersPath         *string
	logger              *log.Logger
}

type Option func(opts *options) error

func New(
	remotePath string,
	syncIntervalSeconds int,
	opts ...Option,
) (*Bisync, error) {
	if err := checkRclone(); err != nil {
		return nil, err
	}

	options := new(options)
	options.remotePath = remotePath
	options.syncIntervalSeconds = syncIntervalSeconds
	options.logger = log.Default()

	// defaults
	home, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("get user home directory: %w", err)
	}
	remoteState := localStateDir(home, remotePath)

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

	for _, path := range []string{options.dataPath, options.backupPath, options.configPath, options.workdirPath} {
		if err := os.MkdirAll(path, 0o700); err != nil {
			return nil, fmt.Errorf("create directory %s: %w", path, err)
		}
	}

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
		options.filtersPath = &path
	}

	return &Bisync{
		o:      options,
		runner: execRcloneRunner{},
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

func WithLogger(logger *log.Logger) Option {
	return func(opts *options) error {
		if logger == nil {
			return fmt.Errorf("logger must not be nil")
		}
		opts.logger = logger
		return nil
	}
}

func localStateDir(home string, rcloneRemotePath string) string {
	localState := filepath.Join(home, ".local", "state")
	return filepath.Join(localState, "rclone", cutRemote(rcloneRemotePath))
}

func cutRemote(rcloneRemotePath string) string {
	cut, _, _ := strings.Cut(rcloneRemotePath, ":")
	return cut
}

// --- rclone version ---

func checkRclone() error {
	_, err := exec.LookPath("rclone")
	if errors.Is(err, exec.ErrNotFound) {
		return fmt.Errorf("find rclone in PATH: %w", err)
	}
	if err != nil {
		return fmt.Errorf("check rclone: %w", err)
	}

	cmd := exec.Command("rclone", "--version")
	out, err := cmd.CombinedOutput()
	if err != nil {
		return fmt.Errorf("read rclone version: %w", err)
	}

	firstLine, _, _ := strings.Cut(string(out), "\n")
	ok := checkVersion(firstLine, RcloneGeMajorVersion, RcloneGeMinorVersion)
	if !ok {
		return fmt.Errorf("incorrect rclone version, must be greater or equal %d.%d", RcloneGeMajorVersion, RcloneGeMinorVersion)
	}

	return nil
}

func checkVersion(versionLine string, geMajor int, geMinor int) bool {
	re := regexp.MustCompile(`^rclone v(\d+)\.(\d+)`)
	matches := re.FindStringSubmatch(versionLine)
	if len(matches) != 3 {
		return false
	}

	major, _ := strconv.Atoi(matches[1])
	minor, _ := strconv.Atoi(matches[2])
	if major < geMajor || minor < geMinor {
		return false
	}

	return true
}

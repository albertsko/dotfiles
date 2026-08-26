package rclonebisync

import (
	"context"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"time"
)

const (
	backupRetention = 30 * 24 * time.Hour
	backupTimestamp = "20060102T150405Z"
	maxDelete       = "95"
)

func (b *Bisync) Configure(ctx context.Context) error {
	configPath := b.rcloneConfigPath()
	if err := b.runner.Run(ctx, "config", "--config", configPath); err != nil {
		return fmt.Errorf("configure rclone: %w", err)
	}

	return b.validateRemote(ctx)
}

func (b *Bisync) Service(ctx context.Context) error {
	err := b.syncOnce(ctx)
	if ctx.Err() != nil {
		return nil
	}
	if err != nil {
		statusErr := b.recordHealth(ctx, "failed", err.Error())
		return errors.Join(err, statusErr)
	}

	return b.recordHealth(ctx, "healthy", "synchronized successfully")
}

func (b *Bisync) syncOnce(ctx context.Context) error {
	configured, err := b.isConfigured()
	if err != nil {
		return err
	}
	if !configured {
		return fmt.Errorf("run gdrive config before starting the service")
	}
	if err := b.validateRemote(ctx); err != nil {
		return err
	}

	initialized, err := b.isInitialized()
	if err != nil {
		return err
	}
	if !initialized {
		return b.initialize(ctx)
	}
	if err := b.runBisync(ctx, "--track-renames"); err != nil {
		return fmt.Errorf("synchronize: %w", err)
	}

	return b.pruneBackups(ctx)
}

func (b *Bisync) validateRemote(ctx context.Context) error {
	configPath := b.rcloneConfigPath()
	remotes, err := b.runner.Output(ctx, "listremotes", "--config", configPath)
	if err != nil {
		return fmt.Errorf("list rclone remotes: %w", err)
	}

	remoteName := cutRemote(b.o.remotePath) + ":"
	if !containsRemote(remotes, remoteName) {
		return fmt.Errorf("configuration must contain a remote named %s", remoteName)
	}
	return nil
}

func (b *Bisync) initialize(ctx context.Context) error {
	configPath := b.rcloneConfigPath()
	accessCheckPath := filepath.Join(b.o.dataPath, accessCheckFile)
	if err := validateAccessCheckPath(accessCheckPath); err != nil {
		return err
	}
	if err := b.runner.Run(ctx, "touch", accessCheckPath, "--config", configPath); err != nil {
		return fmt.Errorf("create local access check %s: %w", accessCheckPath, err)
	}

	remoteAccessCheckPath := joinRemotePath(b.o.remotePath, accessCheckFile)
	if err := b.runner.Run(ctx, "copyto", accessCheckPath, remoteAccessCheckPath, "--config", configPath); err != nil {
		return fmt.Errorf("create remote access check %s: %w", remoteAccessCheckPath, err)
	}

	if err := b.runBisync(ctx, "--resync-mode", "newer"); err != nil {
		return fmt.Errorf("initial reconciliation: %w", err)
	}

	return b.pruneBackups(ctx)
}

func (b *Bisync) runBisync(ctx context.Context, extraArgs ...string) error {
	timestamp := time.Now().UTC().Format(backupTimestamp)
	args := []string{
		"bisync", b.o.dataPath, b.o.remotePath,
		"--config", b.rcloneConfigPath(),
		"--workdir", b.o.workdirPath,
		"--filters-file", *b.o.filtersPath,
		"--check-access",
		"--drive-skip-gdocs",
		"--drive-skip-shortcuts",
		"--max-delete", maxDelete,
		"--resilient",
		"--recover",
		"--max-lock", "2m",
		"--conflict-resolve", "newer",
		"--backup-dir1", filepath.Join(b.o.backupPath, timestamp),
		"--backup-dir2", joinRemotePath(b.remoteBackupPath(), timestamp),
		"--log-file", b.o.logPath,
		"--log-file-max-size", "10M",
		"--log-file-max-backups", "3",
		"--log-file-max-age", "30d",
		"--log-level", "INFO",
	}
	args = append(args, extraArgs...)
	if err := b.runner.Run(ctx, args...); err != nil {
		return fmt.Errorf("rclone bisync exited with code %d; see %s: %w", exitCode(err), b.o.logPath, err)
	}
	return nil
}

func (b *Bisync) pruneBackups(ctx context.Context) error {
	if err := b.runner.Run(ctx, "mkdir", b.remoteBackupPath(), "--config", b.rcloneConfigPath()); err != nil {
		return fmt.Errorf("create remote backup directory: %w", err)
	}
	if err := b.pruneBackupPath(ctx, b.o.backupPath); err != nil {
		return fmt.Errorf("prune local backups: %w", err)
	}
	if err := b.pruneBackupPath(ctx, b.remoteBackupPath()); err != nil {
		return fmt.Errorf("prune remote backups: %w", err)
	}
	return nil
}

func (b *Bisync) pruneBackupPath(ctx context.Context, backupPath string) error {
	output, err := b.runner.Output(ctx, "lsf", backupPath, "--dirs-only", "--format", "p", "--config", b.rcloneConfigPath())
	if err != nil {
		return err
	}

	cutoff := time.Now().UTC().Add(-backupRetention)
	for directory := range strings.FieldsSeq(string(output)) {
		name := strings.TrimSuffix(directory, "/")
		createdAt, err := time.Parse(backupTimestamp, name)
		if err != nil || !createdAt.Before(cutoff) {
			continue
		}
		if err := b.runner.Run(ctx, "purge", joinRemotePath(backupPath, name), "--config", b.rcloneConfigPath()); err != nil {
			return err
		}
	}
	return nil
}

func (b *Bisync) remoteBackupPath() string {
	return strings.TrimSuffix(b.o.remotePath, "/") + "-bak"
}

func (b *Bisync) isConfigured() (bool, error) {
	info, err := os.Stat(b.rcloneConfigPath())
	if errors.Is(err, os.ErrNotExist) {
		return false, nil
	}
	if err != nil {
		return false, fmt.Errorf("inspect rclone configuration: %w", err)
	}

	return info.Mode().IsRegular() && info.Size() > 0, nil
}

func (b *Bisync) rcloneConfigPath() string {
	return filepath.Join(b.o.configPath, "rclone.conf")
}

func (b *Bisync) isInitialized() (bool, error) {
	entries, err := os.ReadDir(b.o.workdirPath)
	if err != nil {
		return false, fmt.Errorf("inspect bisync work directory: %w", err)
	}
	path1Listings, err := filepath.Glob(filepath.Join(b.o.workdirPath, "*.path1.lst"))
	if err != nil {
		return false, fmt.Errorf("inspect Path1 listings: %w", err)
	}
	path2Listings, err := filepath.Glob(filepath.Join(b.o.workdirPath, "*.path2.lst"))
	if err != nil {
		return false, fmt.Errorf("inspect Path2 listings: %w", err)
	}
	errorListings, err := filepath.Glob(filepath.Join(b.o.workdirPath, "*.lst-err"))
	if err != nil {
		return false, fmt.Errorf("inspect failed listings: %w", err)
	}
	if len(entries) == 0 {
		return false, nil
	}
	if len(path1Listings) != 1 || len(path2Listings) != 1 || len(errorListings) != 0 {
		return false, fmt.Errorf("bisync state is incomplete; manual recovery is required")
	}
	return true, nil
}

func validateAccessCheckPath(path string) error {
	info, err := os.Stat(path)
	if errors.Is(err, os.ErrNotExist) {
		return nil
	}
	if err != nil {
		return fmt.Errorf("inspect access check %s: %w", path, err)
	}
	if !info.Mode().IsRegular() {
		return fmt.Errorf("access check %s must be a regular file", path)
	}

	return nil
}

func containsRemote(remotes []byte, remoteName string) bool {
	return slices.Contains(strings.Fields(string(remotes)), remoteName)
}

func joinRemotePath(remotePath string, name string) string {
	if strings.HasSuffix(remotePath, ":") {
		return remotePath + name
	}

	return strings.TrimSuffix(remotePath, "/") + "/" + name
}

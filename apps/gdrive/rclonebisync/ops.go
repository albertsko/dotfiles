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

func (b *Bisync) Configure(ctx context.Context) error {
	configPath := b.rcloneConfigPath()
	if err := b.runner.Run(ctx, "config", "--config", configPath); err != nil {
		return fmt.Errorf("configure rclone: %w", err)
	}

	remotes, err := b.runner.Output(ctx, "listremotes", "--config", configPath)
	if err != nil {
		return fmt.Errorf("list rclone remotes: %w", err)
	}

	remoteName := cutRemote(b.o.remotePath) + ":"
	if !containsRemote(remotes, remoteName) {
		return fmt.Errorf("configuration must contain a remote named %s", remoteName)
	}

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

	return nil
}

func (b *Bisync) Service(ctx context.Context) error {
	for {
		if ctx.Err() != nil {
			return nil
		}
		if err := b.syncOnce(ctx); err != nil {
			return err
		}
		if !waitForNextSync(ctx, time.Duration(b.o.syncIntervalSeconds)*time.Second) {
			return nil
		}
	}
}

func (b *Bisync) syncOnce(ctx context.Context) error {
	configured, err := b.isConfigured()
	if err != nil {
		return err
	}
	if !configured {
		b.o.logger.Printf("rclone remote %s is not configured; retrying later", cutRemote(b.o.remotePath))
		return nil
	}

	err = b.runBisync(ctx, "--track-renames")
	if err == nil || ctx.Err() != nil {
		return nil
	}

	b.o.logger.Printf("rclone bisync failed: %v", err)
	if exitCode(err) != 7 {
		return nil
	}

	b.o.logger.Printf("rclone bisync requires recovery; reconciling both sides")
	err = b.runBisync(ctx, "--resync-mode", "newer")
	if err == nil || ctx.Err() != nil {
		return nil
	}

	b.o.logger.Printf("rclone bisync recovery failed; retrying later: %v", err)
	return nil
}

func (b *Bisync) runBisync(ctx context.Context, extraArgs ...string) error {
	timestamp := time.Now().UTC().Format("20060102T150405Z")
	args := []string{
		"bisync", b.o.dataPath, b.o.remotePath,
		"--config", b.rcloneConfigPath(),
		"--workdir", b.o.workdirPath,
		"--filters-file", *b.o.filtersPath,
		"--check-access",
		"--drive-skip-gdocs",
		"--drive-skip-shortcuts",
		"--max-delete", "100",
		"--resilient",
		"--recover",
		"--max-lock", "2m",
		"--conflict-resolve", "newer",
		"--suffix-keep-extension",
		"--backup-dir1", filepath.Join(b.o.backupPath, timestamp),
		"--verbose",
	}
	args = append(args, extraArgs...)
	return b.runner.Run(ctx, args...)
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

func waitForNextSync(ctx context.Context, interval time.Duration) bool {
	timer := time.NewTimer(interval)
	defer timer.Stop()

	select {
	case <-ctx.Done():
		return false
	case <-timer.C:
		return true
	}
}

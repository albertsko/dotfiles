package rclonebisync

import (
	"context"
	"errors"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"strconv"
	"strings"
	"time"
)

func (b *Bisync) Status() (string, error) {
	status, err := os.ReadFile(b.o.statusPath)
	if errors.Is(err, os.ErrNotExist) {
		return "", fmt.Errorf("gdrive service has not run yet")
	}
	if err != nil {
		return "", fmt.Errorf("read service status: %w", err)
	}
	return string(status), nil
}

func (b *Bisync) recordHealth(ctx context.Context, health string, message string) error {
	previousHealth, err := b.previousHealth()
	if err != nil {
		return err
	}

	message = strings.ReplaceAll(message, "\n", " ")
	status := fmt.Sprintf("health: %s\nupdated: %s\nmessage: %s\n", health, time.Now().UTC().Format(time.RFC3339), message)
	if err := os.WriteFile(b.o.statusPath, []byte(status), 0o600); err != nil {
		return fmt.Errorf("write service status: %w", err)
	}
	if previousHealth == health || (previousHealth == "" && health == "healthy") {
		return nil
	}

	b.notify(ctx, health, message)
	return nil
}

func (b *Bisync) previousHealth() (string, error) {
	status, err := os.ReadFile(b.o.statusPath)
	if errors.Is(err, os.ErrNotExist) {
		return "", nil
	}
	if err != nil {
		return "", fmt.Errorf("read previous service status: %w", err)
	}

	firstLine, _, _ := strings.Cut(string(status), "\n")
	health, found := strings.CutPrefix(firstLine, "health: ")
	if !found {
		return "", nil
	}
	return health, nil
}

func (b *Bisync) notify(ctx context.Context, health string, message string) {
	if runtime.GOOS != "darwin" {
		return
	}

	notification := fmt.Sprintf("display notification %s with title %s", strconv.Quote(message), strconv.Quote("gdrive "+health))
	if err := exec.CommandContext(ctx, "osascript", "-e", notification).Run(); err != nil {
		b.o.logger.Printf("send health notification: %v", err)
	}
}

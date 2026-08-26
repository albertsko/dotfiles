package rclonebisync

import (
	"context"
	"errors"
	"os"
	"os/exec"
	"time"
)

type rcloneRunner interface {
	Run(ctx context.Context, args ...string) error
	Output(ctx context.Context, args ...string) ([]byte, error)
}

type exitCoder interface {
	ExitCode() int
}

type execRcloneRunner struct{}

func (execRcloneRunner) Run(ctx context.Context, args ...string) error {
	cmd := exec.CommandContext(ctx, "rclone", args...)
	cmd.Cancel = func() error {
		return cmd.Process.Signal(os.Interrupt)
	}
	cmd.WaitDelay = 95 * time.Second
	cmd.Stdin = os.Stdin
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func (execRcloneRunner) Output(ctx context.Context, args ...string) ([]byte, error) {
	cmd := exec.CommandContext(ctx, "rclone", args...)
	cmd.Cancel = func() error {
		return cmd.Process.Signal(os.Interrupt)
	}
	cmd.WaitDelay = 95 * time.Second
	cmd.Stdin = os.Stdin
	cmd.Stderr = os.Stderr
	return cmd.Output()
}

func exitCode(err error) int {
	var exitErr exitCoder
	if !errors.As(err, &exitErr) {
		return -1
	}

	return exitErr.ExitCode()
}

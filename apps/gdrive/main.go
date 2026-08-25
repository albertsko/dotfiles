package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/albertsko/dotfiles/apps/gdrive/rclonebisync"
)

const (
	remotePath          = "gdrive:sync"
	syncIntervalSeconds = 300
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	if err := run(ctx, os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "gdrive: %v\n", err)
		os.Exit(1)
	}
}

func run(ctx context.Context, args []string) error {
	command, err := parseCommand(args)
	if err != nil {
		return err
	}

	client, err := rclonebisync.New(remotePath, syncIntervalSeconds)
	if err != nil {
		return fmt.Errorf("create rclone bisync client: %w", err)
	}

	switch command {
	case "config":
		return client.Configure(ctx)
	case "service":
		return client.Service(ctx)
	default:
		return fmt.Errorf("unknown command: %s", command)
	}
}

func parseCommand(args []string) (string, error) {
	if len(args) == 0 {
		return "service", nil
	}
	if len(args) > 1 {
		return "", fmt.Errorf("unexpected argument: %s", args[1])
	}
	if args[0] != "config" && args[0] != "service" {
		return "", fmt.Errorf("unknown command: %s", args[0])
	}

	return args[0], nil
}

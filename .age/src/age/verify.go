package age

import (
	"context"
	"os"
	"os/signal"
	"syscall"
)

func (v *Vault) verify() error {
	return nil
}

func (v *Vault) unlock() error {
	return nil
}

func tempDir() (path string, err error, cleanup func()) {
	dir, err := os.MkdirTemp("", "*")
	if err != nil {
		return "", err, func() {}
	}

	ctx, cancel := signal.NotifyContext(
		context.Background(),
		syscall.SIGTERM,
		syscall.SIGINT,
	)

	deletedCh := make(chan struct{})

	go func() {
		defer close(deletedCh)
		defer cancel()
		<-ctx.Done()

		os.RemoveAll(dir)
	}()

	cleanupFunc := func() {
		cancel()
		<-deletedCh
	}

	return dir, nil, cleanupFunc
}

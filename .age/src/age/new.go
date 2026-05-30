package age

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
)

func init() {
	required := []string{"age", "tar", "bash", "echo", "head", "grep"}
	for _, req := range required {
		_, err := exec.LookPath(req)
		if err != nil {
			log.Fatalf("required bin %s is not installed or not in PATH\n", req)
		}
	}
}

// Vault stores validated age material and runs age helper scripts.
type Vault struct {
	rootPath string

	identity   []byte
	recipient  []byte
	passphrase []byte
}

// Option configures an Vault before validation.
type Option func(*Vault) error

// NewVault creates an Vault from explicit script paths and options.
func NewVault(rootPath string, opts ...Option) (*Vault, error) {
	v := &Vault{
		rootPath: rootPath,
	}

	for _, opt := range opts {
		if opt == nil {
			return nil, fmt.Errorf("age vault option is nil")
		}

		err := opt(v)
		if err != nil {
			return nil, err
		}
	}

	// err := v.verify()
	// if err != nil {
	// 	return nil, err
	// }

	return v, nil
}

// WithIdentityReader reads identity material from r.
func WithIdentityReader(r io.Reader) Option {
	return func(v *Vault) error {
		identity, err := io.ReadAll(r)
		if err != nil || len(identity) == 0 {
			return fmt.Errorf("failed to read identity: %w", err)
		}
		v.identity = identity
		return nil
	}
}

// WithIdentityPassphrase sets the passphrase used by batchpass scripts.
func WithIdentityPassphrase(passphrase []byte) Option {
	return func(v *Vault) error {
		v.passphrase = bytes.Clone(passphrase)
		return nil
	}
}

// WithIdentityPath reads identity material from path.
func WithIdentityPath(path string) Option {
	return func(v *Vault) error {
		file, err := os.Open(path)
		if err != nil {
			return fmt.Errorf("failed to open identity path '%s': %w", path, err)
		}
		defer file.Close()

		return WithIdentityReader(file)(v)
	}
}

// WithRecipientReader reads recipient material from r.
func WithRecipientReader(r io.Reader) Option {
	return func(v *Vault) error {
		recipient, err := io.ReadAll(r)
		if err != nil || len(recipient) == 0 {
			return fmt.Errorf("failed to read recipient: %w", err)
		}
		v.recipient = recipient
		return nil
	}
}

// WithRecipientPath reads recipient material from path.
func WithRecipientPath(path string) Option {
	return func(v *Vault) error {
		file, err := os.Open(path)
		if err != nil {
			return fmt.Errorf("failed to open recipient path '%s': %w", path, err)
		}
		defer file.Close()

		return WithRecipientReader(file)(v)
	}
}

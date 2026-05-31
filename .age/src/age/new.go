package age

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"os"
	"os/exec"
	"path/filepath"
)

// init verifies the shell tools used by the vault are available.
func init() {
	required := []string{"age", "tar", "bash", "echo"}
	for _, req := range required {
		_, err := exec.LookPath(req)
		if err != nil {
			log.Fatalf("required bin %s is not installed or not in PATH\n", req)
		}
	}
}

// Vault stores age material and runs age helper scripts.
type Vault struct {
	rootPath string

	identity   []byte
	recipient  []byte
	passphrase []byte
}

// Option configures a Vault before validation.
type Option func(*Vault) error

// NewVault creates a Vault from a root path and options.
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

	err := v.loadRecipient()
	if err != nil {
		return nil, err
	}

	err = v.loadIdentity()
	if err != nil {
		return nil, err
	}

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

// loadRecipient verifies that the configured recipient can encrypt data.
func (v *Vault) loadRecipient() error {
	recipient := bytes.NewReader(v.recipient)
	path, done, err := tempFile(recipient)
	if err != nil {
		return err
	}
	defer done()

	script := fmt.Sprintf(`age -e -R %s -o /dev/null <(echo "")`, path)

	out, err := exec.Command("bash", "-c", script).CombinedOutput()
	outStr := string(out)

	if err != nil {
		return fmt.Errorf("failed to verify recipient: %w\noutput: %s", err, outStr)
	}
	return nil
}

// loadIdentity verifies or unlocks the configured identity.
func (v *Vault) loadIdentity() error {
	identity := bytes.NewReader(v.identity)
	path, done, err := tempFile(identity)
	if err != nil {
		return err
	}
	defer done()

	script := fmt.Sprintf(`age -e -i %s -o /dev/null <(echo "")`, path)
	out, err := exec.Command("bash", "-c", script).CombinedOutput()
	if err == nil {
		return nil
	}

	script = fmt.Sprintf(`AGE_PASSPHRASE=%q age -d -j batchpass %s`, string(v.passphrase), path)
	unlockedIdentity, err := exec.Command("bash", "-c", script).CombinedOutput()
	if err != nil {
		return fmt.Errorf(
			"failed to verify plain identity or unlock passphrase-protected identity: %w\noutput: %s",
			err,
			string(out)+string(unlockedIdentity),
		)
	}

	unlockedPath, unlockedDone, err := tempFile(bytes.NewReader(unlockedIdentity))
	if err != nil {
		return err
	}
	defer unlockedDone()

	script = fmt.Sprintf(`age -e -i %s -o /dev/null <(echo "")`, unlockedPath)
	out, err = exec.Command("bash", "-c", script).CombinedOutput()
	if err != nil {
		return fmt.Errorf(
			"failed to verify unlocked identity: %w\noutput: %s",
			err,
			string(out),
		)
	}

	v.identity = unlockedIdentity
	return nil
}

// tempFile writes reader contents into a temporary file.
func tempFile(r io.Reader) (path string, done func(), err error) {
	f, err := os.CreateTemp("", "*")
	if err != nil {
		return "", nil, fmt.Errorf("failed to create temp file: %w", err)
	}
	defer f.Close()

	path, err = filepath.Abs(f.Name())
	if err != nil {
		return "", nil, fmt.Errorf("failed to get absolute file path: %w", err)
	}

	_, err = io.Copy(f, r)
	if err != nil {
		os.Remove(path)
		return "", nil, fmt.Errorf("failed to copy reader to temp file: %w", err)
	}

	done = func() {
		os.Remove(path)
	}

	return path, done, nil
}

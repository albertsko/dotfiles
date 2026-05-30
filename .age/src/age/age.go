package age

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
)

const encryptedDirSuffix = ".tar.gz.age"

// Encrypt encrypts a file or directory to outputPath.
func (v *Vault) Encrypt(in string) (out string, err error) {
	return "", nil
}

// Decrypt decrypts inputPath to outputPath.
// Paths ending in .tar.gz.age are treated as directory payloads.
func (v *Vault) Decrypt(in string) (out string, err error) {
	return "", nil
}

func (v *Vault) loadRecipient(r io.Reader) error {
	path, done, err := tempFile(r)
	defer done()

	script := fmt.Sprintf(`age -e -R %s -o /dev/null <(echo "")`, path)

	out, err := exec.Command("bash", "-c", script).CombinedOutput()
	outStr := string(out)

	if err != nil {
		return fmt.Errorf("failed to verify recipient: %w\noutput: %s", err, outStr)
	}
	return nil
}

func (v *Vault) loadIdentity(r io.Reader) error {
	return nil
}

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

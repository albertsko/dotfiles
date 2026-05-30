package age

import (
	"bytes"
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

func (v *Vault) loadRecipient() error {
	recipient := bytes.NewReader(v.recipient)
	path, done, err := tempFile(recipient)
	defer done()

	script := fmt.Sprintf(`age -e -R %s -o /dev/null <(echo "")`, path)

	out, err := exec.Command("bash", "-c", script).CombinedOutput()
	outStr := string(out)

	if err != nil {
		return fmt.Errorf("failed to verify recipient: %w\noutput: %s", err, outStr)
	}
	return nil
}

func (v *Vault) loadIdentity() error {
	// TODO:
	// 1. get a tempFile using tempFile()

	// 2. find out if identity is a valid identity or if it is passphrase protected
	// 3. if passphrase protected then use v.passphrase and batchpass plugin for unlocking plain identity and store the unlocked plain identity in v.identity
	// 4. if identity not valid then return err
	//   - identity should be valid only for two happy paths:
	//     - regular identity created with `age-keygen -o`
	//     - passphrase protected identity created with `age-keygen -o /tmp/key-plaintext.txt && age -p -a -o identity.age /tmp/key-plaintext.txt`
	// 5. finally return nil

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

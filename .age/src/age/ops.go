package age

import (
	"bytes"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

var (
	ErrSymlink             = errors.New("symlinks are not supported")
	ErrUnsupportedFileType = errors.New("unsupported file type")
	ErrNotEncrypted        = errors.New("not an age encrypted file")
)

const (
	EncryptedFileSuffix = ".age"
	EncryptedDirSuffix  = ".tar.gz.age"
	TarGzSuffix         = ".tar.gz"
)

// Encrypt encrypts files to <path>.age, and directories to <path>.tar.gz.age.
func (v *Vault) Encrypt(in string) (out string, err error) {
	in = filepath.Clean(in)

	info, err := classifyPath(in)
	if err != nil {
		return "", err
	}

	recipient := bytes.NewReader(v.recipient)
	recipientPath, done, err := tempFile(recipient)
	if err != nil {
		return "", err
	}
	defer done()

	if info.IsDir() {
		out = in + EncryptedDirSuffix
		script := fmt.Sprintf(
			`tar -C %s -czf - %s | age -e -R %s -o %s`,
			filepath.Dir(in),
			filepath.Base(in),
			recipientPath,
			out,
		)

		cmdOut, err := exec.Command("bash", "-c", script).CombinedOutput()
		if err != nil {
			return "", fmt.Errorf("failed to encrypt directory: %w\noutput: %s", err, string(cmdOut))
		}

		return out, nil
	}

	out = in + EncryptedFileSuffix
	script := fmt.Sprintf(`age -e -R %s -o %s %s`, recipientPath, out, in)

	cmdOut, err := exec.Command("bash", "-c", script).CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("failed to encrypt file: %w\noutput: %s", err, string(cmdOut))
	}

	return out, nil
}

// Decrypt restores .age files and extracts decrypted .tar.gz payloads.
func (v *Vault) Decrypt(in string) (out string, err error) {
	in = filepath.Clean(in)

	info, err := classifyPath(in)
	if err != nil {
		return "", err
	}

	if info.IsDir() {
		return "", fmt.Errorf("%w: %s", ErrUnsupportedFileType, in)
	}

	if !strings.HasSuffix(in, EncryptedFileSuffix) {
		return "", fmt.Errorf("%w: %s", ErrNotEncrypted, in)
	}

	identity := bytes.NewReader(v.identity)
	identityPath, done, err := tempFile(identity)
	if err != nil {
		return "", err
	}
	defer done()

	out = strings.TrimSuffix(in, EncryptedFileSuffix)
	script := fmt.Sprintf(`age -d -i %s -o %s %s`, identityPath, out, in)

	cmdOut, err := exec.Command("bash", "-c", script).CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("failed to decrypt file: %w\noutput: %s", err, string(cmdOut))
	}

	if !strings.HasSuffix(out, TarGzSuffix) {
		return out, nil
	}

	script = fmt.Sprintf(`tar -xzf %s -C %s`, out, filepath.Dir(out))
	cmdOut, err = exec.Command("bash", "-c", script).CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("failed to extract decrypted archive: %w\noutput: %s", err, string(cmdOut))
	}

	err = os.Remove(out)
	if err != nil {
		return "", err
	}

	return strings.TrimSuffix(out, TarGzSuffix), nil
}

func classifyPath(path string) (fs.FileInfo, error) {
	info, err := os.Lstat(path)
	if err != nil {
		return nil, err
	}

	mode := info.Mode()

	switch {
	case mode.IsRegular(), mode.IsDir():
		return info, nil

	case mode&os.ModeSymlink != 0:
		return nil, fmt.Errorf("%w: %s", ErrSymlink, path)

	default:
		return nil, fmt.Errorf("%w: %s: %s", ErrUnsupportedFileType, path, mode.Type())
	}
}

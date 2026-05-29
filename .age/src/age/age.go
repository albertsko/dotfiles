package age

import (
	"fmt"
	"os/exec"
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

func (v *Vault) loadRecipient(path string) error {
	script := fmt.Sprintf(`age -e -R %s -o /dev/null <(echo "")`, path)

	out, err := exec.Command("bash", "-c", script).CombinedOutput()
	outStr := string(out)

	if err != nil {
		return fmt.Errorf("failed to verify recipient: %w\noutput: %s", err, outStr)
	}
	return nil
}

func (v *Vault) loadIdentity(path string) error {
	return nil
}

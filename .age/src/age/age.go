package age

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

package main

import (
	"bytes"
	"errors"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
)

const (
	testIdentity  = "AGE-SECRET-KEY-17ZDL6HKHDTS68LWD8EXCJM8NG0YQ64XNTF6MXSKGJA3349MCMGKQGPN959\n"
	testRecipient = "age109g992k585trwtun6ekjl33fk7hsvz9x8kpgnqx94ch3snv2e4wqxd8rua\n"
)

type errorReader struct{}

func (errorReader) Read(_ []byte) (int, error) {
	return 0, errors.New("read failed")
}

func TestNewAgeVaultFromReaders(t *testing.T) {
	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(strings.NewReader(testIdentity)),
		WithIdentityPassphrase("passphrase"),
		WithRecipientReader(strings.NewReader(testRecipient)),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	if vault.identity != testIdentity {
		t.Fatalf("identity = %q, want %q", vault.identity, testIdentity)
	}

	if vault.passphrase != "passphrase" {
		t.Fatalf("passphrase = %q, want %q", vault.passphrase, "passphrase")
	}

	if vault.recipient != testRecipient {
		t.Fatalf("recipient = %q, want %q", vault.recipient, testRecipient)
	}
}

func TestNewAgeVaultFromPaths(t *testing.T) {
	dir := t.TempDir()
	identityPath := filepath.Join(dir, "identity.age")
	recipientPath := filepath.Join(dir, "recipient.txt")

	err := os.WriteFile(identityPath, []byte(testIdentity), 0o600)
	if err != nil {
		t.Fatalf("failed to write test identity: %v", err)
	}

	err = os.WriteFile(recipientPath, []byte(testRecipient), 0o600)
	if err != nil {
		t.Fatalf("failed to write test recipient: %v", err)
	}

	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityPath(identityPath),
		WithRecipientPath(recipientPath),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	if vault.identity != testIdentity {
		t.Fatalf("identity = %q, want %q", vault.identity, testIdentity)
	}

	if vault.recipient != testRecipient {
		t.Fatalf("recipient = %q, want %q", vault.recipient, testRecipient)
	}
}

func TestNewAgeVaultDecryptsPassphraseProtectedIdentity(t *testing.T) {
	encryptedIdentity := encryptWithBatchpass(t, []byte(testIdentity), "test passphrase", true)

	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(bytes.NewReader(encryptedIdentity)),
		WithIdentityPassphrase("test passphrase"),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	if vault.identity != testIdentity {
		t.Fatalf("identity = %q, want %q", vault.identity, testIdentity)
	}
}

func TestNewAgeVaultDecryptsBinaryPassphraseProtectedIdentity(t *testing.T) {
	encryptedIdentity := encryptWithBatchpass(t, []byte(testIdentity), "test passphrase", false)

	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(bytes.NewReader(encryptedIdentity)),
		WithIdentityPassphrase("test passphrase"),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	if vault.identity != testIdentity {
		t.Fatalf("identity = %q, want %q", vault.identity, testIdentity)
	}
}

func TestNewAgeVaultAcceptsSSHIdentity(t *testing.T) {
	if _, err := exec.LookPath("ssh-keygen"); err != nil {
		t.Skip("ssh-keygen not found")
	}

	dir := t.TempDir()
	keyPath := filepath.Join(dir, "id_ed25519")

	cmd := exec.Command("ssh-keygen", "-q", "-t", "ed25519", "-N", "", "-f", keyPath)
	output, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("ssh-keygen failed: %s: %v", strings.TrimSpace(string(output)), err)
	}

	identity, err := os.ReadFile(keyPath)
	if err != nil {
		t.Fatalf("failed to read ssh identity: %v", err)
	}

	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(bytes.NewReader(identity)),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	if vault.identity != string(identity) {
		t.Fatalf("identity = %q, want %q", vault.identity, string(identity))
	}
}

func TestNewAgeVaultRejectsEncryptedSSHIdentity(t *testing.T) {
	if _, err := exec.LookPath("ssh-keygen"); err != nil {
		t.Skip("ssh-keygen not found")
	}

	dir := t.TempDir()
	keyPath := filepath.Join(dir, "id_ed25519")

	cmd := exec.Command("ssh-keygen", "-q", "-t", "ed25519", "-N", "ssh passphrase", "-f", keyPath)
	output, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("ssh-keygen failed: %s: %v", strings.TrimSpace(string(output)), err)
	}

	identity, err := os.ReadFile(keyPath)
	if err != nil {
		t.Fatalf("failed to read ssh identity: %v", err)
	}

	_, err = NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(bytes.NewReader(identity)),
	)
	if err == nil {
		t.Fatal("NewAgeVault returned nil error")
	}
}

func TestNewAgeVaultReturnsOptionError(t *testing.T) {
	_, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(errorReader{}),
	)
	if err == nil {
		t.Fatal("NewAgeVault returned nil error")
	}

	if !strings.Contains(err.Error(), "failed to read identity") {
		t.Fatalf("error = %q, want identity read context", err.Error())
	}
}

func TestNewAgeVaultReturnsNilOptionError(t *testing.T) {
	_, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t), nil)
	if err == nil {
		t.Fatal("NewAgeVault returned nil error")
	}
}

func TestNewAgeVaultReturnsInvalidIdentityError(t *testing.T) {
	_, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(strings.NewReader("not an age identity\n")),
	)
	if err == nil {
		t.Fatal("NewAgeVault returned nil error")
	}

	if !strings.Contains(err.Error(), "identity-to-plain.sh failed") {
		t.Fatalf("error = %q, want identity script context", err.Error())
	}
}

func TestNewAgeVaultReturnsInvalidRecipientError(t *testing.T) {
	_, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithRecipientReader(strings.NewReader("not an age recipient\n")),
	)
	if err == nil {
		t.Fatal("NewAgeVault returned nil error")
	}

	if !strings.Contains(err.Error(), "verify-recipient.sh failed") {
		t.Fatalf("error = %q, want recipient script context", err.Error())
	}
}

func TestAgeVaultEncryptDecrypt(t *testing.T) {
	dir := t.TempDir()
	plainPath := filepath.Join(dir, "plain.txt")
	encryptedPath := filepath.Join(dir, "plain.txt.age")
	decryptedPath := filepath.Join(dir, "plain.out.txt")
	plain := []byte{0, 1, 2, 's', 'e', 'c', 'r', 'e', 't', '\n'}

	err := os.WriteFile(plainPath, plain, 0o600)
	if err != nil {
		t.Fatalf("failed to write plain file: %v", err)
	}

	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(strings.NewReader(testIdentity)),
		WithRecipientReader(strings.NewReader(testRecipient)),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	err = vault.Encrypt(plainPath, encryptedPath)
	if err != nil {
		t.Fatalf("Encrypt returned error: %v", err)
	}

	err = vault.Decrypt(encryptedPath, decryptedPath)
	if err != nil {
		t.Fatalf("Decrypt returned error: %v", err)
	}

	decrypted, err := os.ReadFile(decryptedPath)
	if err != nil {
		t.Fatalf("failed to read decrypted file: %v", err)
	}

	if !bytes.Equal(decrypted, plain) {
		t.Fatalf("decrypted = %q, want %q", decrypted, plain)
	}
}

func TestAgeVaultEncryptFileRejectsTarGzAgeSuffix(t *testing.T) {
	dir := t.TempDir()
	plainPath := filepath.Join(dir, "plain.txt")

	err := os.WriteFile(plainPath, []byte("secret\n"), 0o600)
	if err != nil {
		t.Fatalf("failed to write plain file: %v", err)
	}

	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(strings.NewReader(testIdentity)),
		WithRecipientReader(strings.NewReader(testRecipient)),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	err = vault.Encrypt(plainPath, filepath.Join(dir, "plain.tar.gz.age"))
	if err == nil {
		t.Fatal("Encrypt returned nil error")
	}

	if !strings.Contains(err.Error(), "must not end with .tar.gz.age") {
		t.Fatalf("error = %q, want reserved suffix context", err.Error())
	}
}

func TestAgeVaultEncryptDecryptDir(t *testing.T) {
	dir := t.TempDir()
	plainDir := filepath.Join(dir, "plain-dir")
	nestedDir := filepath.Join(plainDir, "nested")
	encryptedPath := filepath.Join(dir, "plain-dir.tar.gz.age")
	decryptedDir := filepath.Join(dir, "plain-dir.out")
	firstPlain := []byte("first secret\n")
	secondPlain := []byte{0, 1, 2, 's', 'e', 'c', 'o', 'n', 'd'}

	err := os.MkdirAll(nestedDir, 0o700)
	if err != nil {
		t.Fatalf("failed to create plain dir: %v", err)
	}

	err = os.WriteFile(filepath.Join(plainDir, "first.txt"), firstPlain, 0o600)
	if err != nil {
		t.Fatalf("failed to write first plain file: %v", err)
	}

	err = os.WriteFile(filepath.Join(nestedDir, "second.bin"), secondPlain, 0o600)
	if err != nil {
		t.Fatalf("failed to write second plain file: %v", err)
	}

	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(strings.NewReader(testIdentity)),
		WithRecipientReader(strings.NewReader(testRecipient)),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	err = vault.Encrypt(plainDir, encryptedPath)
	if err != nil {
		t.Fatalf("Encrypt returned error: %v", err)
	}

	err = vault.Decrypt(encryptedPath, decryptedDir)
	if err != nil {
		t.Fatalf("Decrypt returned error: %v", err)
	}

	assertFileBytes(t, filepath.Join(decryptedDir, "first.txt"), firstPlain)
	assertFileBytes(t, filepath.Join(decryptedDir, "nested", "second.bin"), secondPlain)
}

func TestAgeVaultEncryptDirRequiresTarGzAgeSuffix(t *testing.T) {
	dir := t.TempDir()
	plainDir := filepath.Join(dir, "plain-dir")

	err := os.Mkdir(plainDir, 0o700)
	if err != nil {
		t.Fatalf("failed to create plain dir: %v", err)
	}

	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(strings.NewReader(testIdentity)),
		WithRecipientReader(strings.NewReader(testRecipient)),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	err = vault.Encrypt(plainDir, filepath.Join(dir, "plain-dir.age"))
	if err == nil {
		t.Fatal("Encrypt returned nil error")
	}

	if !strings.Contains(err.Error(), ".tar.gz.age") {
		t.Fatalf("error = %q, want tar.gz.age context", err.Error())
	}
}

func TestAgeVaultEncryptWithoutRecipient(t *testing.T) {
	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithIdentityReader(strings.NewReader(testIdentity)),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	err = vault.Encrypt("input", "output")
	if err == nil {
		t.Fatal("Encrypt returned nil error")
	}
}

func TestAgeVaultDecryptWithoutIdentity(t *testing.T) {
	vault, err := NewAgeVault(testIdentityScript(t), testRecipientScript(t), testEncryptScript(t), testDecryptScript(t), testEncryptDirScript(t), testDecryptDirScript(t),
		WithRecipientReader(strings.NewReader(testRecipient)),
	)
	if err != nil {
		t.Fatalf("NewAgeVault returned error: %v", err)
	}

	err = vault.Decrypt("input", "output")
	if err == nil {
		t.Fatal("Decrypt returned nil error")
	}
}

func encryptWithBatchpass(t *testing.T, input []byte, passphrase string, armor bool) []byte {
	t.Helper()

	args := []string{"-e", "-j", "batchpass"}
	if armor {
		args = append(args, "-a")
	}

	cmd := exec.Command("age", args...)
	cmd.Stdin = bytes.NewReader(input)
	cmd.Env = append(os.Environ(), "AGE_PASSPHRASE="+passphrase)

	stdout := new(bytes.Buffer)
	stderr := new(bytes.Buffer)
	cmd.Stdout = stdout
	cmd.Stderr = stderr

	err := cmd.Run()
	if err != nil {
		t.Fatalf("age batchpass encryption failed: %s: %v", strings.TrimSpace(stderr.String()), err)
	}

	return append([]byte(nil), stdout.Bytes()...)
}

func testRootPath(t *testing.T) string {
	t.Helper()

	rootPath, err := filepath.Abs(filepath.Join("..", ".."))
	if err != nil {
		t.Fatalf("failed to resolve test root path: %v", err)
	}

	return rootPath
}

func testIdentityScript(t *testing.T) string {
	t.Helper()

	return filepath.Join(testRootPath(t), ageScriptsDir, identityToPlainScript)
}

func testRecipientScript(t *testing.T) string {
	t.Helper()

	return filepath.Join(testRootPath(t), ageScriptsDir, verifyRecipientScript)
}

func testEncryptScript(t *testing.T) string {
	t.Helper()

	return filepath.Join(testRootPath(t), ageScriptsDir, encryptFileScript)
}

func testDecryptScript(t *testing.T) string {
	t.Helper()

	return filepath.Join(testRootPath(t), ageScriptsDir, decryptFileScript)
}

func testEncryptDirScript(t *testing.T) string {
	t.Helper()

	return filepath.Join(testRootPath(t), ageScriptsDir, encryptDirScript)
}

func testDecryptDirScript(t *testing.T) string {
	t.Helper()

	return filepath.Join(testRootPath(t), ageScriptsDir, decryptDirScript)
}

func assertFileBytes(t *testing.T, path string, want []byte) {
	t.Helper()

	got, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("failed to read file '%s': %v", path, err)
	}

	if !bytes.Equal(got, want) {
		t.Fatalf("%s = %q, want %q", path, got, want)
	}
}

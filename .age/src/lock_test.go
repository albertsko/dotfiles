package main

import (
	"crypto/sha256"
	"encoding/hex"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"testing"
)

func TestNewSecretsLockFromSecrets(t *testing.T) {
	rootPath := t.TempDir()
	lockPath := filepath.Join(rootPath, ".secrets.lock")
	content := []byte("secret contents\n")

	err := os.WriteFile(filepath.Join(rootPath, "secret"), content, 0o600)
	if err != nil {
		t.Fatalf("failed to write test secret: %v", err)
	}

	lock, err := NewSecretsLockFromSecrets(lockPath, rootPath, []string{"secret"})
	if err != nil {
		t.Fatalf("NewSecretsLockFromSecrets returned error: %v", err)
	}

	sum := sha256.Sum256(content)
	want := "secret\t" + hex.EncodeToString(sum[:]) + "\n"

	if lock.String() != want {
		t.Fatalf("String() = %q, want %q", lock.String(), want)
	}
}

func TestNewSecretsLockFromLockPath(t *testing.T) {
	rootPath := t.TempDir()
	lockPath := filepath.Join(rootPath, ".secrets.lock")
	firstHash := strings.Repeat("a", sha256HexLen)
	secondHash := strings.Repeat("b", sha256HexLen)

	err := os.WriteFile(lockPath, []byte("first\t"+firstHash+"\nsecond\t"+secondHash+"\n"), 0o600)
	if err != nil {
		t.Fatalf("failed to write test lock: %v", err)
	}

	lock, err := NewSecretsLockFromLockPath(lockPath, rootPath)
	if err != nil {
		t.Fatalf("NewSecretsLockFromLockPath returned error: %v", err)
	}

	wantOrder := []string{"first", "second"}
	if !slices.Equal(lock.secretsOrdered, wantOrder) {
		t.Fatalf("secretsOrdered = %#v, want %#v", lock.secretsOrdered, wantOrder)
	}

	if lock.secrets["first"] != firstHash {
		t.Fatalf("lock.secrets[first] = %q, want %q", lock.secrets["first"], firstHash)
	}

	if lock.secrets["second"] != secondHash {
		t.Fatalf("lock.secrets[second] = %q, want %q", lock.secrets["second"], secondHash)
	}
}

func TestNewSecretsLockFromMissingLockPath(t *testing.T) {
	rootPath := t.TempDir()
	lockPath := filepath.Join(rootPath, ".secrets.lock")

	lock, err := NewSecretsLockFromLockPath(lockPath, rootPath)
	if err != nil {
		t.Fatalf("NewSecretsLockFromLockPath returned error: %v", err)
	}

	if lock.String() != "" {
		t.Fatalf("String() = %q, want empty string", lock.String())
	}
}

func TestSecretsLockAddFile(t *testing.T) {
	rootPath := t.TempDir()
	content := []byte("secret contents\n")

	err := os.WriteFile(filepath.Join(rootPath, "secret"), content, 0o600)
	if err != nil {
		t.Fatalf("failed to write test secret: %v", err)
	}

	lock := &SecretsLock{
		rootPath:       rootPath,
		secrets:        make(secret),
		secretsOrdered: make([]string, 0),
	}

	err = lock.Add("secret")
	if err != nil {
		t.Fatalf("Add returned error: %v", err)
	}

	sum := sha256.Sum256(content)
	wantHash := hex.EncodeToString(sum[:])

	if lock.secrets["secret"] != wantHash {
		t.Fatalf("lock.secrets[secret] = %q, want %q", lock.secrets["secret"], wantHash)
	}

	wantOrder := []string{"secret"}
	if !slices.Equal(lock.secretsOrdered, wantOrder) {
		t.Fatalf("secretsOrdered = %#v, want %#v", lock.secretsOrdered, wantOrder)
	}
}

func TestSecretsLockAddDir(t *testing.T) {
	rootPath := t.TempDir()
	dirPath := filepath.Join(rootPath, "secret-dir")

	err := os.Mkdir(dirPath, 0o700)
	if err != nil {
		t.Fatalf("failed to create test dir: %v", err)
	}

	err = os.WriteFile(filepath.Join(dirPath, "secret"), []byte("secret contents\n"), 0o600)
	if err != nil {
		t.Fatalf("failed to write test secret: %v", err)
	}

	lock := &SecretsLock{
		rootPath:       rootPath,
		secrets:        make(secret),
		secretsOrdered: make([]string, 0),
	}

	err = lock.Add("secret-dir")
	if err != nil {
		t.Fatalf("Add returned error: %v", err)
	}

	wantHash, err := hashDirState(dirPath)
	if err != nil {
		t.Fatalf("hashDirState returned error: %v", err)
	}

	if lock.secrets["secret-dir"] != wantHash {
		t.Fatalf("lock.secrets[secret-dir] = %q, want %q", lock.secrets["secret-dir"], wantHash)
	}

	wantOrder := []string{"secret-dir"}
	if !slices.Equal(lock.secretsOrdered, wantOrder) {
		t.Fatalf("secretsOrdered = %#v, want %#v", lock.secretsOrdered, wantOrder)
	}
}

func TestSecretsLockAddExistingSecretKeepsOrder(t *testing.T) {
	rootPath := t.TempDir()

	err := os.WriteFile(filepath.Join(rootPath, "secret"), []byte("old contents\n"), 0o600)
	if err != nil {
		t.Fatalf("failed to write test secret: %v", err)
	}

	lock := &SecretsLock{
		rootPath: rootPath,
		secrets: secret{
			"secret": "old-hash",
		},
		secretsOrdered: []string{"secret"},
	}

	err = os.WriteFile(filepath.Join(rootPath, "secret"), []byte("new contents\n"), 0o600)
	if err != nil {
		t.Fatalf("failed to update test secret: %v", err)
	}

	err = lock.Add("secret")
	if err != nil {
		t.Fatalf("Add returned error: %v", err)
	}

	wantOrder := []string{"secret"}
	if !slices.Equal(lock.secretsOrdered, wantOrder) {
		t.Fatalf("secretsOrdered = %#v, want %#v", lock.secretsOrdered, wantOrder)
	}
}

func TestSecretsLockWrite(t *testing.T) {
	lockPath := filepath.Join(t.TempDir(), ".secrets.lock")
	hash := strings.Repeat("a", sha256HexLen)
	lock := &SecretsLock{
		lockPath: lockPath,
		secrets: secret{
			"secret": hash,
		},
		secretsOrdered: []string{"secret"},
	}

	err := lock.Write()
	if err != nil {
		t.Fatalf("Write returned error: %v", err)
	}

	got, err := os.ReadFile(lockPath)
	if err != nil {
		t.Fatalf("failed to read lock file: %v", err)
	}

	want := lock.String()
	if string(got) != want {
		t.Fatalf("written lock = %q, want %q", string(got), want)
	}
}

func TestSecretsLockWriteReplacesExistingLockFile(t *testing.T) {
	lockPath := filepath.Join(t.TempDir(), ".secrets.lock")
	err := os.WriteFile(lockPath, []byte("old contents\n"), 0o400)
	if err != nil {
		t.Fatalf("failed to write old lock file: %v", err)
	}

	hash := strings.Repeat("a", sha256HexLen)
	lock := &SecretsLock{
		lockPath: lockPath,
		secrets: secret{
			"secret": hash,
		},
		secretsOrdered: []string{"secret"},
	}

	err = lock.Write()
	if err != nil {
		t.Fatalf("Write returned error: %v", err)
	}

	got, err := os.ReadFile(lockPath)
	if err != nil {
		t.Fatalf("failed to read lock file: %v", err)
	}

	want := lock.String()
	if string(got) != want {
		t.Fatalf("written lock = %q, want %q", string(got), want)
	}

	info, err := os.Stat(lockPath)
	if err != nil {
		t.Fatalf("failed to stat lock file: %v", err)
	}

	if info.Mode().Perm()&0o200 == 0 {
		t.Fatalf("lock file mode = %v, want owner-writable file", info.Mode().Perm())
	}
}

func TestSecretsLockWriteWithoutLockPath(t *testing.T) {
	lock := &SecretsLock{}

	err := lock.Write()
	if err == nil {
		t.Fatal("Write returned nil error without lockPath")
	}
}

func TestSecretsLockDiff(t *testing.T) {
	current := &SecretsLock{
		secrets: secret{
			"same":    "same-hash",
			"changed": "new-hash",
			"added":   "added-hash",
		},
		secretsOrdered: []string{"same", "changed", "added"},
	}
	previous := &SecretsLock{
		secrets: secret{
			"removed": "removed-hash",
			"same":    "same-hash",
			"changed": "old-hash",
			"extra":   "some-extra",
			"xd":      "xd",
		},
		secretsOrdered: []string{"removed", "same", "changed", "extra", "xd"},
	}

	got := current.Diff(previous)
	want := []string{"changed", "added", "removed", "extra", "xd"}

	if !slices.Equal(got, want) {
		t.Fatalf("Diff() = %#v, want %#v", got, want)
	}
}

func TestSecretsLockDiffNilOther(t *testing.T) {
	lock := &SecretsLock{
		secrets: secret{
			"first":  "first-hash",
			"second": "second-hash",
		},
		secretsOrdered: []string{"first", "second"},
	}

	got := lock.Diff(nil)
	want := []string{"first", "second"}

	if !slices.Equal(got, want) {
		t.Fatalf("Diff(nil) = %#v, want %#v", got, want)
	}
}

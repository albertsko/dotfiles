package main

import (
	"bytes"
	"slices"
	"strings"
	"testing"
)

type testWriteCloser struct {
	bytes.Buffer
	closed bool
}

func (w *testWriteCloser) Close() error {
	w.closed = true
	return nil
}

func TestSecretsLockWriteAndClose(t *testing.T) {
	writer := &testWriteCloser{}
	lock, err := NewSecretsLock(nil, writer)
	if err != nil {
		t.Fatalf("NewSecretsLock returned error: %v", err)
	}
	lock.secrets["secret"] = strings.Repeat("a", sha256HexLen)
	lock.secretsOrdered = append(lock.secretsOrdered, "secret")

	err = lock.Write()
	if err != nil {
		t.Fatalf("Write returned error: %v", err)
	}

	want := lock.String()
	if writer.String() != want {
		t.Fatalf("writer contents = %q, want %q", writer.String(), want)
	}

	err = lock.Close()
	if err != nil {
		t.Fatalf("Close returned error: %v", err)
	}

	if !writer.closed {
		t.Fatal("Close did not close the writer")
	}
}

func TestSecretsLockWriteWithoutWriter(t *testing.T) {
	lock, err := NewSecretsLock(nil, nil)
	if err != nil {
		t.Fatalf("NewSecretsLock returned error: %v", err)
	}

	err = lock.Write()
	if err == nil {
		t.Fatal("Write returned nil error without writer")
	}

	err = lock.Close()
	if err != nil {
		t.Fatalf("Close returned error without writer: %v", err)
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

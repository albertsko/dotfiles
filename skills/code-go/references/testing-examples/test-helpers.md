# Mechanical setup with visible assertions

Share mechanical setup while keeping the input, action, and expectation visible. This helper creates the file for a test of name trimming.

`example_test.go`:

```go
package example

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func writeInput(t *testing.T, content string) string {
	t.Helper()
	path := filepath.Join(t.TempDir(), "input.txt")
	if err := os.WriteFile(path, []byte(content), 0600); err != nil {
		t.Fatal(err)
	}
	return path
}

func readName(path string) (string, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(data)), nil
}

func TestReadName(t *testing.T) {
	path := writeInput(t, "  Ada Lovelace\n")
	got, err := readName(path)
	if err != nil {
		t.Fatal(err)
	}
	if got != "Ada Lovelace" {
		t.Fatalf("name = %q, want %q", got, "Ada Lovelace")
	}
}
```

`t.Helper` attributes setup failures to the call site. The operation under test returns errors so callers can test error behavior separately.

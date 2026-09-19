# Resources that survive through subtests

Use `t.Cleanup` when a helper acquires a resource needed by the caller or its subtests. This file stays open through a parallel subtest, then closes before its temporary directory is removed.

`example_test.go`:

```go
package example

import (
	"os"
	"path/filepath"
	"testing"
)

func openOutput(t *testing.T) *os.File {
	t.Helper()
	file, err := os.Create(filepath.Join(t.TempDir(), "output.txt"))
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() {
		if err := file.Close(); err != nil {
			t.Errorf("close output: %v", err)
		}
	})
	return file
}

func TestFileSurvivesParentReturn(t *testing.T) {
	file := openOutput(t)
	t.Run("write", func(t *testing.T) {
		t.Parallel()
		if _, err := file.WriteString("hello"); err != nil {
			t.Fatal(err)
		}
		got, err := os.ReadFile(file.Name())
		if err != nil {
			t.Fatal(err)
		}
		if string(got) != "hello" {
			t.Fatalf("content = %q, want %q", got, "hello")
		}
	})
}
```

The parallel subtest resumes after the parent function returns. A `defer file.Close()` in the helper or parent would close the file too soon. `t.Cleanup` runs after subtests and in reverse registration order, so the file closes before `t.TempDir` removes its directory.

Only one child uses this file. Concurrent writers would need a separate synchronization decision.

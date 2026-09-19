# Independent resources in parallel tests

Use parallel subtests when each owns its mutable state and resources. Each case below gets a separate directory, even though the file names match. The module must declare Go 1.22 or later for separate loop variables per iteration.

`example_test.go`:

```go
package example

import (
	"os"
	"path/filepath"
	"testing"
)

func TestParallelFiles(t *testing.T) {
	for _, content := range []string{"alpha", "beta"} {
		t.Run(content, func(t *testing.T) {
			t.Parallel()
			path := filepath.Join(t.TempDir(), "value.txt")
			if err := os.WriteFile(path, []byte(content), 0600); err != nil {
				t.Fatal(err)
			}
			got, err := os.ReadFile(path)
			if err != nil {
				t.Fatal(err)
			}
			if string(got) != content {
				t.Fatalf("content = %q, want %q", got, content)
			}
		})
	}
}
```

Run `go test -race -count=1 .` on a supported platform. The race detector checks executed memory accesses. It does not establish safe sharing of files or external systems.

For modules using pre-1.22 language semantics, add `content := content` before `t.Run`.

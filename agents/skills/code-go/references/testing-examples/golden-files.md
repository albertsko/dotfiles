# Reviewed golden output

Use a golden file when expected output is easier to review as a file. This member list has a heading and one line per name, preserving input order.

`example_test.go`:

```go
package example

import (
	"flag"
	"fmt"
	"os"
	"strings"
	"testing"
)

var update = flag.Bool("update", false, "rewrite golden output")

func renderMembers(names []string) string {
	var out strings.Builder
	fmt.Fprintln(&out, "Members:")
	for _, name := range names {
		fmt.Fprintf(&out, "- %s\n", name)
	}
	return out.String()
}

func TestRenderMembers(t *testing.T) {
	got := renderMembers([]string{"Ada", "Linus"})
	path := "testdata/members.golden"
	if *update {
		if err := os.WriteFile(path, []byte(got), 0600); err != nil {
			t.Fatal(err)
		}
		return
	}
	want, err := os.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	if got != string(want) {
		t.Fatalf("output mismatch\nwant:\n%s\ngot:\n%s", want, got)
	}
}
```

`testdata/members.golden` (including the final newline):

```text
Members:
- Ada
- Linus
```

## Verify

1. Run `go test -count=1 .`. A missing file or changed content fails.
2. When the intended output changes, run `go test -count=1 . -update`.
3. Review the changed fixture against the requirement, then rerun without `-update`.

For larger output, replace the full output dump with a useful text or image diff.

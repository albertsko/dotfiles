# The Go test executable as a helper process

Use the test executable as a helper when the caller needs controlled process output and an exit status. This helper writes to stdout and stderr, then exits with status 3.

`example_test.go`:

```go
package example

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"os"
	"os/exec"
	"testing"
	"time"
)

func TestCommandFailure(t *testing.T) {
	executable, err := os.Executable()
	if err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	cmd := exec.CommandContext(ctx, executable, "-test.run=^TestHelperProcess$", "--", "fail")
	cmd.Dir = t.TempDir()
	cmd.Env = []string{"CODE_GO_HELPER_PROCESS=1"}
	stdout, err := cmd.Output()
	var exitErr *exec.ExitError
	if !errors.As(err, &exitErr) || exitErr.ExitCode() != 3 {
		t.Fatalf("helper error = %v, want exit 3", err)
	}
	if string(stdout) != "partial\n" || string(exitErr.Stderr) != "unavailable\n" {
		t.Fatalf("stdout/stderr = %q/%q, want %q/%q", stdout, exitErr.Stderr, "partial\n", "unavailable\n")
	}
}

func TestHelperProcess(_ *testing.T) {
	if os.Getenv("CODE_GO_HELPER_PROCESS") != "1" {
		return
	}
	args := flag.Args()
	if len(args) != 1 || args[0] != "fail" {
		fmt.Fprintf(os.Stderr, "unknown helper operation: %q\n", args)
		os.Exit(2)
	}
	fmt.Fprintln(os.Stdout, "partial")
	fmt.Fprintln(os.Stderr, "unavailable")
	os.Exit(3)
}
```

The environment marker keeps ordinary test runs from invoking the helper behavior. In the child, `-test.run` selects only the helper, and `--` separates its arguments from test flags. Missing or unknown operations fail explicitly.

The marked helper calls `os.Exit` so its output contains only the intended bytes, without the test runner's result.

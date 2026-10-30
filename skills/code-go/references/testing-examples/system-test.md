# A real application in a controlled environment

Run the real executable when startup, configuration, and filesystem paths must work together. This command reads JSON configuration relative to its working directory and prints a greeting. The test needs the Go toolchain, and `WaitDelay` requires Go 1.20 or later.

`main.go`:

```go
package main

import (
	"encoding/json"
	"fmt"
	"os"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func run(args []string) error {
	if len(args) != 1 {
		return fmt.Errorf("usage: greeting config.json")
	}
	data, err := os.ReadFile(args[0])
	if err != nil {
		return err
	}
	var config struct {
		Name string `json:"name"`
	}
	if err := json.Unmarshal(data, &config); err != nil {
		return err
	}
	if config.Name == "" {
		return fmt.Errorf("name is required")
	}
	_, err = fmt.Fprintf(os.Stdout, "Hello, %s!\n", config.Name)
	return err
}
```

`example_test.go`:

```go
package main

import (
	"context"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"testing"
	"time"
)

func TestGreetingCommand(t *testing.T) {
	binary := filepath.Join(t.TempDir(), "greeting")
	if runtime.GOOS == "windows" {
		binary += ".exe"
	}
	buildCtx, cancelBuild := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancelBuild()
	build := exec.CommandContext(buildCtx, "go", "build", "-o", binary, ".")
	build.WaitDelay = time.Second
	if output, err := build.CombinedOutput(); err != nil {
		t.Fatalf("build: %v\n%s", err, output)
	}

	workDir := t.TempDir()
	config := []byte(`{"name":"Ada"}`)
	if err := os.WriteFile(filepath.Join(workDir, "config.json"), config, 0600); err != nil {
		t.Fatal(err)
	}
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	cmd := exec.CommandContext(ctx, binary, "config.json")
	cmd.Dir = workDir
	cmd.Env = []string{}
	cmd.WaitDelay = time.Second
	output, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("run: %v\n%s", err, output)
	}
	if string(output) != "Hello, Ada!\n" {
		t.Fatalf("output = %q, want %q", output, "Hello, Ada!\n")
	}
}
```

The test bounds both build and execution time. It uses the current host and toolchain, so other deployment environments need their own checks.

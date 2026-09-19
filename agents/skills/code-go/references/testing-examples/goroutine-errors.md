# Worker results and bounded waits

Send worker results to the test goroutine for assertions. This test checks that empty input produces a specific validation error, with a timeout if the worker does not finish.

`example_test.go`:

```go
package example

import (
	"errors"
	"testing"
	"time"
)

var errEmptyName = errors.New("empty name")

func validateName(name string) error {
	if name == "" {
		return errEmptyName
	}
	return nil
}

func TestWorkerReportsError(t *testing.T) {
	result := make(chan error, 1)
	go func() {
		result <- validateName("")
	}()

	timer := time.NewTimer(time.Second)
	defer timer.Stop()
	select {
	case err := <-result:
		if !errors.Is(err, errEmptyName) {
			t.Fatalf("error = %v, want %v", err, errEmptyName)
		}
	case <-timer.C:
		t.Fatal("worker did not finish")
	}
}
```

Run `go test -race -count=1 .` on a supported platform. The channel synchronizes the result. Its buffer lets this finite worker send and finish even if the test times out first.

For blocking or ongoing workers, add cancellation and wait for them to stop during cleanup.

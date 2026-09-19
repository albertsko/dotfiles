# Computation over explicit inputs

Pass external state into a computation when reading it inside the function makes testing difficult. Here the caller supplies the time, and an entry expires at its deadline.

`example_test.go`:

```go
package example

import (
	"testing"
	"time"
)

func expired(now, deadline time.Time) bool {
	return !now.Before(deadline)
}

func TestExpiredAtDeadline(t *testing.T) {
	deadline := time.Date(2026, 1, 1, 0, 0, 0, 0, time.UTC)
	if !expired(deadline, deadline) {
		t.Fatal("expected expiration at the deadline")
	}
}
```

Changing `!now.Before(deadline)` to `now.After(deadline)` makes this boundary test fail.

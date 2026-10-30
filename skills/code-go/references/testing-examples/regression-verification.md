# Verify a regression and report the result

Verify a regression test by running it against both the fault and the fix. Available capacity must stay nonnegative when reservations exceed capacity. Use a temporary module for this demonstration.

`example_test.go` (with the fix):

```go
package example

import "testing"

func available(capacity, reserved int) int {
	remaining := capacity - reserved
	if remaining < 0 {
		return 0
	}
	return remaining
}

func TestAvailableNeverNegative(t *testing.T) {
	if got := available(2, 3); got != 0 {
		t.Fatalf("available(2, 3) = %d, want 0", got)
	}
}
```

## Verify

1. **V1:** In the temporary module, replace the body of `available` with the original faulty computation: `return capacity - reserved`. Run `go test -count=1 -run '^TestAvailableNeverNegative$' .`. Expect failure with `available(2, 3) = -1, want 0`.
2. **V2:** Restore the fixed function shown above. Run the same command and expect a pass.
3. **V3:** Run `go test -count=1 ./...` for this example module. In a real repository, also run the checks appropriate to the changed packages and dependencies.

## Report

After performing those checks, a concise report can state:

- **Regression evidence:** The focused command failed with the old computation: `available(2, 3) = -1, want 0`.
- **Fixed behavior:** `go test -count=1 -run '^TestAvailableNeverNegative$' .` passed with the fix.
- **Package check:** `go test -count=1 ./...` passed.
- **Scope:** The check covers over-reserved capacity. This example has no external prerequisites or skipped tests. Report actual failures and skipped checks when adapting it.

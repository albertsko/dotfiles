# Named table tests

Use named table cases when setup and assertions are shared. This test checks that a size at or below the limit is allowed.

`example_test.go`:

```go
package example

import "testing"

func withinLimit(size, limit int) bool {
	return size <= limit
}

func TestWithinLimit(t *testing.T) {
	const limit = 10
	tests := []struct {
		name string
		size int
		want bool
	}{
		{name: "below limit", size: 9, want: true},
		{name: "at limit", size: 10, want: true},
		{name: "above limit", size: 11, want: false},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := withinLimit(tt.size, limit); got != tt.want {
				t.Fatalf("withinLimit(%d, %d) = %t, want %t", tt.size, limit, got, tt.want)
			}
		})
	}
}
```

Run with `-v` to see the case names.

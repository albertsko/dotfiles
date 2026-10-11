package examples

import (
	"errors"
	"fmt"
	"testing"
)

func TestCapacityLimitStillSharesElements(t *testing.T) {
	original := []int{1, 2, 3}
	limited := original[:1:1]
	limited[0] = 9
	if original[0] != 9 {
		t.Fatal("capacity limits do not isolate existing elements")
	}
	grown := append(limited, 8)
	if original[1] != 2 || grown[1] != 8 {
		t.Fatal("append should allocate separate storage")
	}
	independent := append([]int(nil), original...)
	independent[0] = 7
	if original[0] != 9 {
		t.Fatal("an element copy should isolate these scalar values")
	}
}

type operationError struct{ message string }

func (e *operationError) Error() string { return e.message }

func checkedError(e *operationError) error {
	if e == nil {
		return nil
	}
	return e
}

func TestTypedNilBoundary(t *testing.T) {
	var concrete *operationError
	var wrapped error = concrete
	if wrapped == nil {
		t.Fatal("typed nil in an interface is not a nil interface")
	}
	if checkedError(concrete) != nil {
		t.Fatal("return a literal nil at the interface boundary")
	}
}

func finish(write func() error, close func() error) (err error) {
	defer func() { err = errors.Join(err, close()) }()
	return write()
}

func TestCleanupPreservesBothErrors(t *testing.T) {
	writeErr, closeErr := errors.New("write failed"), errors.New("close failed")
	err := finish(func() error { return fmt.Errorf("persist: %w", writeErr) }, func() error { return closeErr })
	if !errors.Is(err, writeErr) || !errors.Is(err, closeErr) {
		t.Fatal("both failures must remain inspectable")
	}
	if err := finish(func() error { return writeErr }, func() error { return nil }); !errors.Is(err, writeErr) {
		t.Fatal("successful cleanup must preserve the primary failure")
	}
}

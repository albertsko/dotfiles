# Reusable tests for an implementation contract

Use a shared suite when consumers implement an interface with behavioral requirements. Here a missing key returns `ErrNotFound`, and stored values can be retrieved unchanged.

`example_test.go`:

```go
package example

import (
	"errors"
	"testing"
)

var ErrNotFound = errors.New("key not found")

type Store interface {
	Put(key, value string) error
	Get(key string) (string, error)
}

func CheckStoreContract(t *testing.T, newStore func(*testing.T) Store) {
	t.Helper()
	t.Run("missing key", func(t *testing.T) {
		store := newStore(t)
		_, err := store.Get("missing")
		if !errors.Is(err, ErrNotFound) {
			t.Fatalf("error = %v, want %v", err, ErrNotFound)
		}
	})
	t.Run("round trip", func(t *testing.T) {
		store := newStore(t)
		if err := store.Put("language", "Go"); err != nil {
			t.Fatal(err)
		}
		got, err := store.Get("language")
		if err != nil {
			t.Fatal(err)
		}
		if got != "Go" {
			t.Fatalf("value = %q, want %q", got, "Go")
		}
	})
}

type memoryStore map[string]string

func (s memoryStore) Put(key, value string) error {
	s[key] = value
	return nil
}

func (s memoryStore) Get(key string) (string, error) {
	value, ok := s[key]
	if !ok {
		return "", ErrNotFound
	}
	return value, nil
}

func TestMemoryStoreContract(t *testing.T) {
	CheckStoreContract(t, func(_ *testing.T) Store {
		return memoryStore{}
	})
}
```

Supply a different factory to check another implementation. Each case gets a fresh store. Factories needing resources can register cleanup through the supplied `*testing.T`.

For consumers to import the suite, move the helper into a non-`_test.go` file in a test-support package. Keep the production interface and error contract in their owning package.

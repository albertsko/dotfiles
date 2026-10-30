# An HTTP client against a local server

Use a local HTTP server to check a client's requests and response handling. This test checks that `Delete` sends `DELETE /users/{id}` and maps HTTP 404 to `ErrNotFound`. `atomic.Bool` requires Go 1.19 or later.

`example_test.go`:

```go
package example

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"net/http/httptest"
	"net/url"
	"sync/atomic"
	"testing"
	"time"
)

var ErrNotFound = errors.New("user not found")

type providerClient struct {
	baseURL    string
	httpClient *http.Client
}

func (c providerClient) Delete(ctx context.Context, id string) error {
	req, err := http.NewRequestWithContext(ctx, http.MethodDelete, c.baseURL+"/users/"+url.PathEscape(id), nil)
	if err != nil {
		return err
	}
	resp, err := c.httpClient.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	switch resp.StatusCode {
	case http.StatusNotFound:
		return ErrNotFound
	case http.StatusNoContent:
		return nil
	default:
		return fmt.Errorf("unexpected HTTP status %d", resp.StatusCode)
	}
}

func TestProviderDeleteNotFound(t *testing.T) {
	var requested atomic.Bool
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		requested.Store(true)
		if r.Method != http.MethodDelete || r.URL.Path != "/users/42" {
			t.Errorf("request = %s %s, want DELETE /users/42", r.Method, r.URL.Path)
		}
		w.WriteHeader(http.StatusNotFound)
	}))
	t.Cleanup(server.Close)

	httpClient := server.Client()
	httpClient.Timeout = time.Second
	t.Cleanup(httpClient.CloseIdleConnections)
	client := providerClient{baseURL: server.URL, httpClient: httpClient}
	err := client.Delete(context.Background(), "42")
	if !errors.Is(err, ErrNotFound) {
		t.Fatalf("error = %v, want %v", err, ErrNotFound)
	}
	if !requested.Load() {
		t.Fatal("provider was not called")
	}
}
```

Run `go test -race -count=1 .` on a supported platform. The atomic flag detects a client that returns `ErrNotFound` without contacting the server. The handler uses `t.Errorf` because it runs outside the test goroutine.

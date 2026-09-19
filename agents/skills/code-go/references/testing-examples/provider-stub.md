# A provider stub for application behavior

Use a stub to check application decisions after a provider failure. A failed send returns `"pending"` and preserves the error. Production supplies the real adapter through the same interface.

`example_test.go`:

```go
package example

import (
	"context"
	"errors"
	"testing"
)

type sender interface {
	Send(context.Context, string) error
}

type deliveryService struct {
	sender sender
}

func (d deliveryService) Deliver(ctx context.Context, message string) (string, error) {
	if err := d.sender.Send(ctx, message); err != nil {
		return "pending", err
	}
	return "sent", nil
}

type senderStub struct {
	err error
}

func (s senderStub) Send(context.Context, string) error {
	return s.err
}

func TestDeliveryFailureReturnsPending(t *testing.T) {
	unavailable := errors.New("provider unavailable")
	service := deliveryService{sender: senderStub{err: unavailable}}
	state, err := service.Deliver(context.Background(), "hello")
	if state != "pending" || !errors.Is(err, unavailable) {
		t.Fatalf("got (%q, %v), want (%q, %v)", state, err, "pending", unavailable)
	}
}
```

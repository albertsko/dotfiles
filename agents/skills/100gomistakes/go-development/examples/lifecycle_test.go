package examples

import (
	"context"
	"sync"
	"testing"
	"testing/synctest"
	"time"
)

func TestCancelAndJoin(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		ctx, cancel := context.WithCancel(context.Background())
		defer cancel()
		var workers sync.WaitGroup
		cleaned := false
		workers.Go(func() {
			<-ctx.Done()
			cleaned = true
		})
		cancel()
		workers.Wait()
		if !cleaned {
			t.Fatal("Wait must observe completed cleanup")
		}
	})
}

func TestDeadlineWithoutWallClockSleep(t *testing.T) {
	synctest.Test(t, func(t *testing.T) {
		ctx, cancel := context.WithTimeout(context.Background(), time.Hour)
		defer cancel()
		<-ctx.Done()
		if ctx.Err() != context.DeadlineExceeded {
			t.Fatal(ctx.Err())
		}
	})
}

# Executable examples

These small tests demonstrate specific contracts. They are not a substitute for applying the owning rule to a real task.

| Example | Owning rules | What it demonstrates |
| --- | --- | --- |
| [Slice ownership](ownership_test.go) | G57 | Capacity limiting isolates later append, but existing elements remain shared. |
| [Typed nil](ownership_test.go) | G90 | Return a literal nil when a concrete pointer represents no error. |
| [Cleanup failures](ownership_test.go) | G105 | errors.Join preserves primary and cleanup causes. |
| [Cancellation and completion](lifecycle_test.go) | G139, G257 | Cancellation signals termination, while Wait observes completed cleanup. Fake time avoids a one-hour wall-clock wait. |
| [Go 1.21 loop mode](loops-go121/loop_test.go) and [Go 1.22 loop mode](loops-go122/loop_test.go) | G70, G125, G179 | Declarations change identity at the language gate. Assignment continues to share a variable. |

From this directory, run `go test -race ./...`. Run `go test ./...` separately in each loop subdirectory, because nested modules are excluded from the parent pattern. The parent examples require Go 1.25 for stable synctest and WaitGroup.Go. The loop modules select older language semantics even when run with a new compiler.

These examples were authored for execution with the available Go 1.27.2 toolchain. Record actual test results separately. Running that toolchain with go 1.21 or go 1.22 module directives checks language selection, not execution by historical toolchains.

Validation on 2026-10-11: Go 1.27.2 on darwin/arm64 passed `go test -race ./...` in the parent example module and `go test ./...` in each loop module. No historical toolchain or other platform was executed for these examples.

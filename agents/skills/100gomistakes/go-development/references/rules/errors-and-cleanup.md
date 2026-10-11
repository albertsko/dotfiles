# Errors and cleanup

Load when: panic/recover, error contracts, wrapping/matching, logging, ignored errors or cleanup failures

<a id="g94"></a>

- **G94** When reporting normal operational failure. Then Return an error as the final result rather than emulating exceptions with panic and recover. Reserve panic for exceptional programmer errors or unusable mandatory dependencies. The error belongs last in an ordinary result list. A mandatory dependency may justify panic when failure leaves the operation unusable, as in a fixed regular expression. Because Callers can handle expected failures explicitly.

  Sources: `BP94`.

<a id="g95"></a>

- **G95** When a deliberate panic recovery boundary is needed. Then Call recover directly in a deferred function executing in the panicking goroutine. A helper called by that function does not provide direct recovery, and another goroutine cannot recover the panic. Use errors for normal failures. Go 1.21 defaults turn panic(nil) into *runtime.PanicNilError, but panicnil=1 or program compatibility defaults for Go <=1.20 preserve the old nil result. Inspect the active workspace or work-module defaults and explicit overrides. Per-file language gates do not select these runtime defaults. Because Ordinary recover calls do not intercept a panic.

  Sources: `BP95`, `RV179`.

<a id="g96"></a>

- **G96** When returning an error from a lower layer. Then Return it directly when no context or classification is useful, or add useful context with %w. Avoid noisy redundant context. Because Context improves diagnosis while preserving the underlying error.

  Sources: `BP96`.

<a id="g97"></a>

- **G97** When callers need an error category or extra structured information. Then Use a custom error type with the required context and deliberate source access. Expose or unwrap the cause only when it is part of the contract. Because A type supports classification beyond a message.

  Sources: `BP97`.

<a id="g98"></a>

- **G98** When the underlying error is an implementation detail. Then Transform the error, for example with %v, rather than exposing it through wrapping. Use %w when cause inspection is intentionally supported. A transformed message can still add diagnostic context. Error classification and exposure of an underlying cause are separate API decisions. Because Wrapping lets callers depend on the cause and couples them to implementation choices.

  Sources: `BP98`.

<a id="g99"></a>

- **G99** When matching an error type that may be wrapped. Then Use errors.As with a non-nil pointer target whose element is an error-implementing type or an interface. A *error variable passed directly as the target is a common misuse diagnosed by vet. Go 1.26+ offers errors.AsType[T] for typed extraction. Is/As traverse multi-error trees from Go 1.20. A type switch only examines the outer error. Because A type switch only sees the outer error and can misclassify wrapped failures.

  Sources: `BP99`, `RV72`, `RV130`, `RV474`.

<a id="g100"></a>

- **G100** When matching a sentinel error that may be wrapped. Then Use errors.Is instead of direct equality. Direct comparison can be valid where an API explicitly returns the sentinel unwrapped. Matching error text is not a substitute for error identity. Because The sentinel may live inside a wrapper.

  Sources: `BP100`.

<a id="g101"></a>

- **G101** When designing recognizable errors. Then Use named sentinel values for expected conditions and custom types for richer unexpected failures. The book gives this as a general guideline, not an exhaustive taxonomy. Use recognizable Err-prefixed names. Structured expected errors can also be legitimate. A non-error sentinel result, such as an absent collection, may fit a domain contract. Because Callers can check stable expected conditions and inspect structured error information.

  Sources: `BP101`.

<a id="g102"></a>

- **G102** When propagating a failure through layers. Then Handle it once: return it with useful context or log it at the handling boundary. Preserve source/target distinctions through contextual wrapping. The single-handling rule addresses the same propagated failure, not a separate failure during cleanup. Because Repeated logging duplicates events and can interleave confusingly under concurrency.

  Sources: `BP102`.

<a id="g103"></a>

- **G103** When an error is intentionally safe to ignore. Then Assign it to the blank identifier and explain a non-obvious reason. Ignoring should be exceptional. Comments should explain why, not repeat syntax. Because Readers can distinguish intentional omission from forgotten handling.

  Sources: `BP103`.

<a id="g104"></a>

- **G104** When a deferred cleanup can fail. Then Choose explicitly to handle, propagate, or deliberately ignore its error, often using a deferred closure. Logging may be appropriate for a cleanup-only failure. Returning from a deferred closure does not return from the surrounding function. Because A plain deferred call silently drops the returned error.

  Sources: `BP104`.

<a id="g105"></a>

- **G105** When propagating cleanup failure through named results. Then Preserve the primary error and report meaningful cleanup failure separately or combine them. On Go 1.20+, errors.Join retains multiple causes for Is/As traversal. Otherwise use a deliberate custom aggregate or retain the primary error and log cleanup failure. Never overwrite a primary error with a nil cleanup result, and log closeErr rather than the unrelated primary variable. Because Unconditional assignment can replace a real failure with nil.

  Sources: `BP105`, `RV130`, `RV148`, `RV149`.

  Example: [Preserving cleanup and primary errors](../../examples/ownership_test.go).

<a id="g253"></a>

- **G253** When combining or inspecting multiple failures. Then On Go 1.20+, use errors.Join or multiple %w operands when callers should inspect all causes. Use errors.Is/As over the tree, or errors.AsType on Go 1.26+. Do not assume errors.Unwrap exposes every child or that a single-chain traversal is complete. Preserve the API decision about exposing underlying failures. Because Multiple errors form a tree whose children must remain inspectable.

  Sources: `RV130`, `RV148`, `RV149`, `RV474`.

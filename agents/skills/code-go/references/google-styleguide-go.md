# Google Go Style Guide (Distilled)

Rules for writing and reviewing Go code, distilled from Google's Go style documents:

- Overview: https://google.github.io/styleguide/go/
- Style Guide (canonical): https://google.github.io/styleguide/go/guide
- Style Decisions (normative): https://google.github.io/styleguide/go/decisions
- Best Practices (advisory): https://google.github.io/styleguide/go/best-practices

Google publishes three tiers: the Style Guide is canonical (enduring rules for all code), Style Decisions is normative (detailed rulings that may evolve), Best Practices is advisory (encouraged, not required). "Idiomatic" means a familiar, prevalent pattern; prefer the idiomatic option when two are otherwise equal.

## Style Principles

In priority order:

1. **Clarity**: the code's purpose and rationale are obvious. Convey purpose through names, commentary, and small functions; comments explain why, not what.
2. **Simplicity**: the most straightforward way that works. Read top to bottom, avoid unnecessary abstraction. Least mechanism: prefer core language constructs, then the standard library, then internal libraries.
3. **Concision**: high signal-to-noise ratio. Avoid repetitive patterns (use table-driven tests), extraneous syntax, opaque names.
4. **Maintainability**: easy to modify correctly; APIs that grow gracefully; minimal dependencies; tests with actionable failures.
5. **Consistency**: the code looks and behaves like the surrounding codebase, but consistency never overrides the principles above. Where the guide is silent, follow nearby code (same file or package).

## Formatting

- Format every file with `gofmt`, including generated code.
- No fixed line length. If a line feels too long, refactor rather than split it. Do not split a line before an indentation change, and do not break long string literals (such as URLs) to fit a length.
- Keep function and method signatures on one line; shorten by extracting local variables, not by wrapping arguments.
- Keep `if`, `for`, `switch`, and `case` lines unbroken. Extract boolean operands into named locals instead of wrapping conditions.
- Put the variable on the left in comparisons: `if result == "foo"`, never Yoda-style.
- In composite literals, put the closing brace at the indentation of the opening brace and end multi-line literals with a trailing comma. Omit repeated type names in slice and map literals (`gofmt -s`).

## Naming

- Use `MixedCaps` or `mixedCaps`, never underscores, even where other languages use them: `MaxLength`, not `MAX_LENGTH`; no `kMaxBufferSize`.
- Underscore exceptions: package names imported only by generated code, `Test`/`Benchmark`/`Example` functions in `_test.go` files, and rare low-level OS/cgo interop. Filenames may contain underscores.

### Packages

- Keep package names short, all lowercase, letters and digits only: `tabwriter`, not `tabWriter` or `tab_writer`.
- Never `util`, `helper`, `common`, `model`, or similar uninformative names. Judge names from the call site: `elliptic.Marshal` reads well, `helper.Marshal` does not.
- Avoid names that common local variables shadow (`url`, `count`).
- Don't repeat the package name in exported symbols: `widget.New`, not `widget.NewWidget`; `db.Load`, not `db.LoadFromDatabase`.

### Variables

- Scale name length with scope: `i` in a 3-line loop, `userCount` at package level. Single-word names are a good start; add words only to disambiguate.
- Omit type words (`users`, not `userSlice`; `userCount`, not `numUsers`) and context already present (inside `UserCount()`, use `count`).
- Don't drop letters to save typing: `Sandbox`, not `Sbx`.
- Use single letters for receivers (one or two letters, an abbreviation of the type, consistent across methods, never `this` or `self`), loop indices, and conventional pairs (`r` for readers/requests, `w` for writers).
- Name constants by role, not value: `MaxPacketSize`, not `Twelve`.
- Keep one case throughout an initialism: `URL`/`url`, `ID`, `DB`, `XMLAPI`/`xmlAPI`; mixed-case initialisms (`gRPC`, `iOS`) keep prose form unless the first letter must change for export (`GRPC`, `IOS`).

### Functions and methods

- No `Get` prefix: `Counts()`, not `GetCounts()`. Use `Compute` or `Fetch` when the call is expensive or can fail remotely.
- Give noun-like names to functions that return something, verb-like names to functions that do something.
- Avoid repetition from the caller's perspective: don't repeat the package name, receiver type, parameter names, or return type in the function name. `(*Config).WriteTo`, not `WriteConfigTo`.
- Put the type last in type-variant functions (`ParseInt`, `ParseInt64`); the primary variant omits it (`Marshal` vs `MarshalText`).

## Package Organization

- Combine packages that clients must import together; split conceptually distinct things into small packages. Short package name plus exported type reads well: `bytes.Buffer`.
- File size is flexible: avoid thousand-line files and swarms of tiny files. There is no one-type-one-file rule; group related code (as `net/http` splits client.go, server.go, cookie.go).
- Don't create `util` grab-bag packages.

## Imports

- Group imports in order: standard library; other packages; protobuf imports; side-effect (`_`) imports.
- Don't rename imports unless necessary: to avoid collisions (rename the most local import), to remove underscores from generated packages, or to fix uninformative names. Renamed protobuf imports take a `pb` suffix (`foopb`), gRPC stubs a `grpc` suffix.
- If a package name collides with a needed local variable, rename the import with a `pkg` suffix (`urlpkg`).
- Use blank imports (`import _`) only in `package main` or tests (exception: `embed`). Never use dot imports (`import .`).

## Commentary and Documentation

- Give every top-level exported name a doc comment, and every unexported declaration with unobvious behavior. Write full sentences beginning with the symbol's name: `// A Request represents ...`.
- Put the package comment immediately above the `package` clause, one per package: `// Package math provides ...`. A `doc.go` file is fine for long package comments.
- No fixed comment line length; be consistent within a file; don't break URLs.
- Name result parameters only when it helps: when a function returns two values of the same type, or when the caller must act on a result (`(ctx Context, cancel func())`). Use naked returns only in small functions.
- Document only deviations from convention:
  - Context: readers assume cancellation interrupts the call and returns `ctx.Err()`; document anything else.
  - Concurrency: readers assume read-only operations are concurrency-safe and mutating ones are not; document when the kind of operation is unclear, when the API synchronizes internally, or when user-implemented interfaces must be safe.
  - Cleanup: state explicit cleanup requirements ("Call Stop to release resources") and show `defer resp.Body.Close()`-style usage when non-obvious.
  - Errors: document significant sentinel errors and error types, including whether a returned error type is a pointer (`*PathError`), so callers can use `errors.Is`/`errors.As`.
- Prefer runnable examples in test files over code in comments; preview godoc rendering (`pkgsite`) during review.
- Boost the signal when a line looks common but isn't: `if err == nil { // if NO error`.

## Errors

- Return `error` as the last result, `nil` on success. Exported functions return the `error` interface, never a concrete error type (a nil concrete pointer in an interface is non-nil).
- Write error strings uncapitalized (unless starting with an exported name) and without trailing punctuation. Capitalize full displayed messages (logs, UI).
- Handle every error deliberately: handle it, return it, or (exceptionally) stop the program. Discarding with `_` needs a comment explaining why discarding is safe.
- No in-band errors: return `(value string, ok bool)` or an `error`, never a sentinel value like `-1` or `""`.
- Indent the error flow: handle the error in the `if` block and let the happy path continue unindented; no `else` after a terminal `return`.
- Give errors structure for callers: sentinel values (`var ErrDuplicate = errors.New(...)`) checked with `errors.Is`, or types with fields. Never match on `err.Error()` strings.
- When adding context, don't restate what the wrapped error already says, and never annotate with a bare "failed:". Choose the verb:
  - `%v` when adding context for humans, or at a system boundary where you translate into a canonical error space (for example gRPC codes) and hide internals.
  - `%w` when callers should reach the underlying error with `errors.Is`/`errors.As`; the wrapped errors become part of your API contract, so document and test them.
  - Place `%w` at the end (`"opening file: %w"`), except sentinel errors that categorize the failure, which go first: `fmt.Errorf("%w: invalid header", ErrParse)`.
- Let the caller log a returned error (avoids double logging). ERROR-level logging is expensive; choose the level by actionability. Guard expensive verbose logging with `if log.V(2) {...}`.
- Don't panic for normal errors. Propagate initialization errors to `main`, which exits with an actionable message (`log.Exit`, no stack trace). Use `log.Fatal` for broken internal invariants. Panics are acceptable only for API misuse (like out-of-range indexing) or as a package-internal mechanism that a deferred `recover` translates to errors before the package boundary (re-panic on unrecognized values). Never `recover` from unexpected panics to keep a server up.
- Use `Must` functions (panic on failure) only for package-level initialization (`regexp.MustCompile`, `template.Must`) and test helpers marked with `t.Helper`, never on user input.

## Language Rules

- Prefer composite literals over field-by-field construction. Specify field names for any struct defined outside the current package; omit zero-value fields unless the zero value is the point.
- Prefer nil slices (`var s []string`) over `s := []string{}`; check emptiness with `len(s) == 0`, never `s == nil`; don't design APIs that distinguish nil from empty slices.
- Prefer `:=` for non-zero initialization, `var` for zero values ready for later use (`var coords Point` before `json.Unmarshal`). Declare protobuf messages as pointers (`new(pb.Bar)` or `&pb.Bar{}`).
- Add size hints (`make` with capacity) only with empirical evidence in performance-sensitive code; default to zero values and composite literals.
- Never copy a value whose methods have pointer receivers, or a struct containing `sync.Mutex` or similar; pass such types by pointer.
- Receiver type: pointer when the method mutates, when the struct has uncopyable fields, or when the struct is large; value for maps, functions, channels, small immutable structs, and built-ins. Keep one receiver style per type. When in doubt, use a pointer.
- Don't pass a pointer just to save bytes (`*string`, `*io.Reader` are wrong); pass large or growing structs and protobufs by pointer.
- Prefer synchronous functions; the caller can always add concurrency, but removing it is hard.
- Make goroutine lifetimes clear: know when and whether each goroutine exits, manage with `context.Context` and `sync.WaitGroup`, and document non-obvious lifetimes. A bare `go f(x)` with undefined shutdown is a leak and a race.
- No redundant `break` in switch cases; use a labeled `break loop` to exit a loop from inside a switch.
- Interfaces: don't create one before a real need. The consumer defines the interface with only the methods it uses; keep interfaces small and unexported when internal. Accept interfaces, return concrete types (return an interface only for encapsulation like `error`, runtime-chosen concrete types, or breaking import cycles). Don't wrap generated RPC clients in hand-made interfaces; test against real transports with a doubled server. Don't export test-double implementations as back doors.
- Generics: use them when business logic needs them; don't reach for them when slices, maps, or an interface suffice, and don't build domain-specific languages (assertion or error-handling frameworks) with them.
- Type aliases (`type T1 = T2`) are rare, mostly for package migrations.
- Prefer `any` over `interface{}`, `%q` over hand-quoted `%s`, backticks for multi-line string constants.
- Never use `math/rand` for keys or anything security-sensitive; use `crypto/rand`.
- Shadowing: `ctx, cancel := context.WithTimeout(ctx, ...)` inside an `if` block shadows `ctx`; declare `var cancel func()` and assign with `=` when the new value must survive the block.

## Global State

- Libraries must not rely on package-level mutable state or export variables that change behavior for all clients. Provide instance types (`New() *Registry`) and pass them explicitly.
- Global state is unsafe when independent functions or tests interact through it, when users are tempted to swap it for test doubles, or when ordering constraints (`init`, flag parsing) apply.
- A package-level default instance is acceptable only if isolated instances also exist, the global API is a thin proxy over the instance API (as `http.Handle` proxies `DefaultServeMux`), only binaries (not libraries) use it, and the package documents its invariants and provides a reset mechanism.
- Define flags only in `package main`; flag names are snake_case, their Go variables mixedCaps (`pollInterval = flag.Duration("poll_interval", ...)`). Configure libraries through their API, not flags.

## Contexts

- Pass `context.Context` as the first parameter, in production code and test helpers alike. Exceptions: HTTP handlers use `req.Context()`, streaming RPCs use the stream's context, tests use `(testing.TB).Context()`, entrypoints use `context.Background()`.
- Don't create base contexts mid-callchain; take the caller's. Don't store a context in a struct field; pass it per method. Never define custom context types or accept interfaces other than `context.Context`.
- Never put a context in an options struct.

## Function Argument Lists

- Keep signatures short; adjacent same-typed parameters invite call-site mistakes. Consider splitting a highly configurable function.
- Option struct (last parameter): prefer when all callers set at least one option, many callers set many options, or options are shared across functions. Named fields self-document, defaults stay omitted, and the struct grows without call-site churn.
- Variadic options (`...Option` closures over an unexported struct): prefer when most callers pass nothing, options are rarely used or numerous, need arguments, or can fail. Options take parameters rather than encode presence (`rpc.FailFast(enable bool)`, not `rpc.EnableFailFast()`); process them in order, last wins. Each option costs significant boilerplate, so use the pattern only when the benefits pay for it.

## String Concatenation

- Few pieces: `+`. Formatted: `fmt.Sprintf` (write directly with `fmt.Fprintf` when targeting an `io.Writer`). Piecemeal building in a loop: `strings.Builder` (linear vs quadratic). Complex templating: `text/template` or `safehtml/template`.

## Command-Line Interfaces

- For sub-command CLIs, prefer `subcommands` (simplest); `cobra` has more features and more pitfalls (obtain the context from `cmd.Context()`, don't create a fresh root context).
- Separate CLI code from library code so the CLI is just one client.

## Testing

The standard `testing` package is the only permitted framework. No assertion libraries, no third-party frameworks.

### Failure messages

- Make every failure diagnosable without reading the test source: what function, what inputs, got, want.
- Format: `YourFunc(%v) = %v, want %v`. Got before want, using the words "got" and "want".
- Use `cmp.Equal` for equality and `cmp.Diff` for readable diffs (`protocmp.Transform()` for protobufs); do not use `reflect.DeepEqual`. `cmp` is test-only. State the diff direction: `diff (-want +got)`.
- Print diffs, not two full dumps, for large values. Use `%q` for strings, `%+v` for small structs.
- Compare full structures with `cmp`, not field by field; use `cmpopts` for approximate or partial comparison. Don't compare output whose exact form other packages own (like `json.Marshal` bytes); compare parsed structures.

### Error semantics in tests

- Don't string-match error messages (change-detector tests). Use `errors.Is` or `cmp` with `cmpopts.EquateErrors`; often testing non-nil vs nil is enough: `if gotErr := err != nil; gotErr != tt.wantErr {...}`.

### Keep going, t.Error vs t.Fatal

- Report all failures in one run: prefer `t.Error`; use `t.Fatal` only when continuing is meaningless (failed setup, unusable intermediate value).
- In table loops without subtests: `t.Error` plus `continue`. Inside `t.Run` subtests: `t.Fatal` is fine (only the subtest ends).
- Never call `t.Fatal`/`t.FailNow` from a goroutine other than the test's own; use `t.Error` and `return` there.

### Test structure

- Use table-driven tests for cases sharing the same checking logic. Cases with different checking logic get separate test functions (for example one table for outputs, one for errors); don't let a case field select conditional behavior inside the loop body, duplicate the test function instead.
- Name each case (a name or description field, or subtest name); never identify a case by table index. Keep subtest names identifier-like: no spaces, slashes, or prose.
- Make subtests independently runnable (`go test -run` filters).
- Use field names in test-case struct literals; omit irrelevant zero-value fields.

### Helpers and setup

- Test helpers do setup and cleanup; their failures are environment failures. Call `t.Helper()`; parameter order is `ctx, t, ...`. Register cleanup with `t.Cleanup`. Helpers may call `t.Fatal` for setup failures, with a message saying what and why.
- Assertion helpers (validate and fail the test) are not idiomatic; fail the test inside the `Test` function. Factored validation returns a value (typically `error`) and lets the test decide; or provide `cmp.Option`s for your types.
- Scope setup to the tests that need it; don't load resources in `init()` or package variables. Amortize expensive shared setup with `sync.Once` (when no teardown is needed) or a custom `TestMain` (only when every test needs setup requiring teardown; split into a `runMain` returning a code so deferred teardown runs before `os.Exit`).

### Doubles and packages

- Test-double packages append `test` to the production package name (`creditcardtest`). Name doubles by kind (`Stub`, `Spy`) or by behavior (`AlwaysDeclines`); prefix test variables with the double's kind (`spyCC`).
- Same-package tests (`package foo`) access unexported identifiers; use a `_test` package (`package foo_test`) for black-box tests, examples showing real qualifiers, or breaking cycles.
- Acceptance-test packages export validation functions taking the user's implementation and returning `error` (like `fstest.TestFS`).
- Test integrations over the real transport: real production client against a doubled server.

## Explicit Non-Decisions

Author's choice, be locally consistent: `var i int` vs `i := 0`; `&File{}` vs `new(File)`; argument order given to `cmp.Diff` (include a direction legend); `errors.New` vs `fmt.Errorf` for constant strings.

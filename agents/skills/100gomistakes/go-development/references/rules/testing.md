# Testing

Load when: test selection/isolation, concurrency, clocks, HTTP/I/O tests, fuzzing, coverage or test cleanup

<a id="g170"></a>

- **G170** When organizing a testing strategy. Then Categorize tests so fast isolated tests and more expensive integration or end-to-end tests can be selected intentionally. The testing pyramid favors many fast deterministic unit tests but is a model, not a numeric quota. Because Unclassified suites waste time and hide the scope of verification.

  Sources: `BP170`.

<a id="g171"></a>

- **G171** When a whole test file belongs to an optional category. Then Use a build constraint with the corresponding go test -tags invocation. Tagged runs also include untagged files. Negated tags can separate mutually exclusive categories. Excluded tests are not reported as skips. The available build-tag syntax depends on the supported Go version. Because Allows category-specific compilation and execution.

  Sources: `BP171`.

<a id="g172"></a>

- **G172** When individual optional tests should report why they did not run. Then Check an explicit environment variable and call t.Skip with a reason. This differs from compile-time file exclusion and can coexist with tags. Arrange CI jobs so optional test categories actually run instead of remaining silently excluded indefinitely. Because Visible skips reduce the chance of forgotten tests.

  Sources: `BP172`.

<a id="g173"></a>

- **G173** When some tests are slow even within a category. Then Use testing.Short and t.Skip, selected with go test -short. Per-test classification can combine with tags or environment gating. Short mode classifies speed, not unit-versus-integration scope. Because Provides a quick feedback mode without redefining test categories.

  Sources: `BP173`.

<a id="g174"></a>

- **G174** When testing concurrent code. Then Run go test -race ./... in local testing or CI and investigate reports. It adds substantial overhead and does not prove absence of races. Broad production use is usually inappropriate. Inspect conflicting access and goroutine-creation stacks. The source treats detector warnings as real race evidence while emphasizing that clean runs can miss races. Because The runtime detector catches unsynchronized accesses on exercised paths.

  Sources: `BP174`.

<a id="g175"></a>

- **G175** When a concurrency test only occasionally exercises the relevant schedule. Then Exercise concurrent paths thoroughly and consider repeated runs or iterations. Repetition improves chances but is not a correctness proof. !race can exclude incompatible tests, but exclusions reduce coverage and need justification. A !race tag removes validation coverage, not the underlying race. Because Dynamic detection can miss unexecuted or unsurfaced races.

  Sources: `BP175`.

<a id="g176"></a>

- **G176** When independent tests spend meaningful time running. Then Mark appropriate tests with t.Parallel and tune -parallel for the workload. Parallel tests are paused until sequential work completes in the relevant scope. Shared state may prevent safe parallelism. Parallel tests pause until their parent scope releases them. The source default concurrency follows GOMAXPROCS. Because Can reduce total suite duration, especially for I/O-heavy tests.

  Sources: `BP176`.

<a id="g177"></a>

- **G177** When checking test isolation. Then Run with -shuffle=on and preserve the reported seed when reproducing a failure. Use the numeric seed for the same ordering. Keep informed about available test modes. A shuffle seed reproduces ordering, not arbitrary goroutine scheduling or external-service state. Because Randomized order exposes hidden dependencies on execution order or shared variables.

  Sources: `BP177`.

<a id="g178"></a>

- **G178** When many cases use the same assertion structure. Then Use table-driven tests with meaningful case names and t.Run subtests. A map is one possible table structure. Use -run=Parent/Subtest to focus diagnosis. Tables should contain related cases with shared assertions, not force unrelated behavior into complex branching. Because Reduces boilerplate and makes new cases and shared improvements easier.

  Sources: `BP178`.

<a id="g179"></a>

- **G179** When parallel table subtests capture iteration variables. Then Check the effective module/file language version. Go 1.22+ gives fresh per-iteration variables when the loop declares them with :=, including three-clause loops. Assignment with = still reuses existing variables. In older language modes or with explicitly shared variables, copy the value or pass it as an argument. Distinct value copies differ from pointers to original slice elements obtained by index. Fresh loop variables do not determine goroutine or parallel-subtest execution order. Because Parallel subtests resume after the parent releases them. Shared loop variables can make several cases test the same value.

  Sources: `BP179`, `RV123`, `RV239`, `RV242`.

  Example: [Loop identity under Go 1.22](../../examples/loops-go122/loop_test.go).

<a id="g180"></a>

- **G180** When testing asynchronous completion. Then Synchronize with an observable event or channel instead of sleeping a guessed duration. Bound waits to prevent hung tests. A test-friendly design should expose useful completion behavior. Because Scheduling and machine load make fixed sleeps flaky.

  Sources: `BP180`.

<a id="g181"></a>

- **G181** When synchronization is truly unavailable in an asynchronous test. Then Use a bounded eventual assertion with a short retry interval. Reconsider design first. Polling is still a fallback rather than a deterministic guarantee. Because Can finish as soon as the condition succeeds and is less brittle than one long sleep.

  Sources: `BP181`.

<a id="g182"></a>

- **G182** When testing behavior based on current time. Then Inject a clock function or small clock interface and supply deterministic times in tests. Keep the dependency on the instance rather than a mutable global so tests remain isolated and parallelizable. The clock example also contains mutation under RLock and an all-expired boundary issue. Preserve dependency injection, not that implementation. Because Direct time.Now calls make results depend on execution timing.

  Sources: `BP182`.

<a id="g183"></a>

- **G183** When the API can naturally accept a time boundary. Then Let callers supply the current time or cutoff time. Simpler but less general than a clock dependency. Useful for external-package tests that cannot set private fields. A caller-supplied cutoff shifts time-selection responsibility into the API contract. Because This makes tests deterministic without a clock stub.

  Sources: `BP183`.

<a id="g184"></a>

- **G184** When testing HTTP handler behavior. Then Use httptest.NewRequest and NewRecorder and assert headers, body, and status. This does not test transport. Source sample contains incidental status/order and transcription defects. Because Direct calls are fast and capture handler behavior.

  Sources: `BP184`.

<a id="g185"></a>

- **G185** When testing an HTTP client. Then Use httptest.NewServer with a controlled handler, its URL, and cleanup. Use NewTLSServer for TLS and NewUnstartedServer when setup must precede startup. Assert outgoing requests as well as response parsing when those requests are part of the client contract. Because Exercises real local HTTP requests without an external service or container.

  Sources: `BP185`.

<a id="g186"></a>

- **G186** When implementing a custom reader. Then Validate the reader contract with iotest.TestReader. Supply the actual expected output. Exercise the reader contract beyond one successful read, including supported optional interfaces. Because Tests returned byte counts, delivered data, and optional reader capabilities.

  Sources: `BP186`.

<a id="g187"></a>

- **G187** When testing I/O consumers against partial reads and failures. Then Use iotest.ErrReader, HalfReader, OneByteReader, TimeoutReader, or TruncateWriter as appropriate. Retry only when the operation contract allows it. The book's retrying readAll is an example, not a universal policy. ErrReader, HalfReader, OneByteReader, TimeoutReader and TruncateWriter cover different failure/partial-I/O behaviors. A retry-all-errors read loop is illustrative, not a universal contract. Because Simulates important I/O behaviors without bespoke fakes.

  Sources: `BP187`.

<a id="g192"></a>

- **G192** When identifying untested behavior. Then Generate a coverage profile and inspect it, including -coverpkg when tests cover other packages. Coverage percentage does not establish assertion quality or correctness. Do not chase 100% blindly. Inspect the coverage HTML report for missing paths. Coverage counts execution, not useful assertions. Because Default reporting can miss coverage exercised from another package.

  Sources: `BP192`.

<a id="g193"></a>

- **G193** When tests should constrain public behavior rather than implementation. Then Use an external package_name_test package. Same-package tests remain useful where internal behavior needs inspection. Because Prevents direct access to private details and keeps tests stable during internal refactoring.

  Sources: `BP193`.

<a id="g194"></a>

- **G194** When repeated test setup can fail. Then Pass *testing.T to test helpers and fail the test there when setup cannot succeed. Keep this behavior in testing helpers, not production APIs. Because Removes repeated production-style error plumbing from each test.

  Sources: `BP194`.

<a id="g195"></a>

- **G195** When test helpers acquire resources. Then Register teardown with t.Cleanup or defer in the owning test. Cleanup callbacks run in reverse registration order. Because Ensures lifecycle responsibility is not forgotten by callers.

  Sources: `BP195`.

<a id="g196"></a>

- **G196** When a package needs shared expensive environment setup. Then Use TestMain to set up, run m.Run, tear down, and preserve the result code. Run teardown before os.Exit, which does not run defers. Shared package infrastructure must not compromise individual test isolation. Because Avoids repeated setup while guaranteeing orderly package-level teardown.

  Sources: `BP196`.

<a id="g255"></a>

- **G255** When testing input parsers or transformations with broad input domains. Then Use Go 1.18+ testing.F with a small meaningful seed corpus and properties about valid/invalid inputs. Set fuzz time/minimization budgets, retain reproducing failures, and manage GOCACHE/fuzz disk usage with go clean -fuzzcache when appropriate. Because Fuzzing explores cases beyond examples, but cache growth and execution budgets need ownership.

  Sources: `RV12`, `RV21`, `RV61`.

<a id="g256"></a>

- **G256** When integration execution needs coverage evidence. Then On Go 1.20+, build with -cover, set GOCOVERDIR for executions, and inspect application coverage alongside unit coverage. For long-running processes use runtime/coverage when normal exit cannot write the needed evidence. Keep coverage separate from assertion quality. Because Integration paths may not run under a unit-test process.

  Sources: `RV122`, `RV125`.

<a id="g257"></a>

- **G257** When testing concurrent time-based behavior on Go 1.25+. Then Consider testing/synctest.Test and Wait for a fake-time bubble whose clock advances when goroutines are durably blocked. Keep race detection and external integration tests where needed. Go 1.24 used experimental Run, not this stable API. Go 1.27 adds synctest.Sleep and httptest.NewTestServer with a fake network. Real external I/O is not automatically virtualized. Because Deterministic scheduling boundaries reduce guessed sleeps but do not prove every concurrency property.

  Sources: `RV349`, `RV405`, `RV541`, `RV546`.

  Example: [Fake time and completion](../../examples/lifecycle_test.go).

<a id="g258"></a>

- **G258** When a test changes process-wide state or allocates lifecycle resources. Then Keep process-wide working-directory/randomness changes out of parallel tests and parallel ancestors. Go 1.24 T.Context/B.Context cancel before cleanup callbacks and T.Chdir/B.Chdir scope directory restoration. Go 1.25 AllocsPerRun rejects parallel execution. Arrange cleanup and join workers explicitly rather than assuming test return proves completion. Because Process-wide mutations can contaminate other tests, while resource cleanup has ordering requirements.

  Sources: `RV386`, `RV436`, `RV493`.

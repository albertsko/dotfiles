# Go Testing

Use this reference to choose, implement, and review Go tests. Follow the repository's supported Go version and existing test conventions.

Read examples only when their conditions match the task. To run one, create a separate temporary directory, run `go mod init example`, and save the files shown. Run `go test -count=1 .` unless the example specifies another command.

## 1. Define what the test must prove

- **Behavior:** Identify the contract or regression and the observable result that distinguishes correct behavior from the fault.
- **Expectation:** Derive expected results from requirements, known regressions, or independently reviewed fixtures. Coverage alone does not establish correctness.
- **Effort:** Match effort to the change and consequences of failure. A change without observable behavior differences may need only existing checks. A test being too costly does not make the behavior untestable.

## 2. Choose the approach

Combine these independent choices:

| Choice | Decision |
| --- | --- |
| Test boundary | Use the smallest boundary that exercises the behavior faithfully. Prefer package API behavior. Test unexported logic directly when its complexity or edge cases are hard to reach through the API. Use integration checks when the interaction matters. |
| Case organization | Use a direct test for one straightforward case. Use [named table cases and `t.Run`](testing-examples/table-tests.md) when cases share setup and assertions. Separate materially different scenarios. |
| Input representation | Keep small inputs inline. Put substantial or realistic inputs in fixtures relative to the package directory. Follow the existing layout, or use `testdata`. |
| Expected output | Assert the properties the contract promises. For complex output, consider a stable representation and a reviewed [golden file](#complex-expected-output). |

For example, a formatter's API test can combine table cases, input fixtures, and golden output.

## 3. Solve specific testing problems

Use only the sections that match the task.

### Extensive setup or mixed side effects

Separate reading state, computing from explicit inputs, and applying effects when setup obscures the logic. See [computation over explicit inputs](testing-examples/pure-logic.md).

- Use realistic inputs and preserve ordering and consistency when moving reads or writes.
- Make dependencies such as paths, ports, timeouts, or command construction controllable through instance configuration with production defaults. Keep options internal when callers do not need them.
- Introduce a narrow consumer interface when a substitute helps. Computation over values may need no interface.
- Keep production changes local. Extract a cohesive function or internal package only when it simplifies testing enough to justify the change. Complex execution systems may benefit from an inspectable command description, resource graph, or rendering plan.

Computation tests do not establish that the real environment supplies the inputs or applies the effects correctly. Use integration checks for those interactions.

### Complex expected output

Choose a stable representation that exposes meaningful differences, such as deterministic text for a graph or tree. See [golden files](testing-examples/golden-files.md) for comparison and deliberate updates.

- Normalize only differences the contract allows, such as irrelevant ordering. Preserve distinctions that would reveal a bug.
- Fail ordinary runs on missing expected output or a mismatch. Show useful differences or preserve actual output for inspection.
- Provide an explicit update mode, such as `-update`. Generated output records current behavior. Review each changed baseline against the requirement, then rerun comparison mode.

### Network or service behavior

Choose according to what must be proved:

- **Connection or protocol behavior:** Use a real local endpoint on an OS-assigned port, such as `127.0.0.1:0`. For HTTP request and response handling, see [the `httptest` example](testing-examples/http-client.md).
- **Service behavior:** Use a controlled service or the existing integration harness. Make credentials, costs, and environment prerequisites explicit. Follow the repository's opt-in mechanism.
- **Caller decisions independent of transport:** Use a narrow substitute or an in-memory connection. Model documented or observed behavior, including relevant failures. See [the provider stub](testing-examples/provider-stub.md).

For endpoints, wait for readiness, bound operations, and close listeners and connections. Synchronize results from server goroutines before reading them.

Stubs and local servers check behavior against a model. Use a controlled integration check when real-provider compatibility matters.

### Subprocess behavior

- **Compatibility with a particular binary:** Run that binary. Skip a missing binary only when the suite treats it as optional. A required CI prerequisite should fail clearly.
- **Caller handling of controlled process outcomes:** Use [a helper process](testing-examples/helper-process.md) to produce the required output and exit status. This checks process handling, not compatibility with a particular binary.

For either approach, isolate the working directory and environment, bound execution, and inspect the exit status and relevant output.

### Contracts for external implementers

When consumers implement a library interface, consider [reusable contract tests](testing-examples/contract-tests.md) for behavior the type system cannot express. Include only behavior required of every implementation. Environment-specific behavior may need separate integration checks.

Provide public setup helpers when consumers need them. Treat exported test support as an API with compatibility obligations.

### Behavior that needs a full system

When behavior depends on the OS, installed components, or full application integration, use a reproducible environment with relevant components pinned. Reuse the repository's harness and integrate with `go test` where practical. Add specialized tools only when the behavior requires them.

Assert an observable result and choose the environment and scenario deliberately. See [the system test](testing-examples/system-test.md) for a real executable using configuration in an isolated working directory.

## 4. Keep tests reliable and understandable

### Visible behavior and useful failures

- Keep the action and expected result close together. Repeat scenario setup when clearer. Share [mechanical setup and cleanup](testing-examples/test-helpers.md) when the helper's purpose is clear at the call site.
- Name cases by their behavior or condition so a failure identifies the case.
- Have setup helpers accept `*testing.T` or the testing interface they need, call `t.Helper`, and fail on setup errors, including fixture reads and writes.
- Return errors from operations whose error behavior the caller needs to test.

### Resource ownership

- Where supported, use `t.TempDir` for temporary directories and `t.Cleanup` for resources that must outlive the test function. See [resource lifetime through subtests](testing-examples/resource-cleanup.md).
- Register cleanup as each resource is acquired, so later setup failures still release it. Check cleanup errors when they affect isolation or the behavior being verified.

### Mutable state and parallelism

- Give each subtest its own mutable inputs and resources when sharing could affect other cases.
- Use `t.Parallel` only when tests and helpers own independent mutable state. Check files, environment, working directory, globals, and external services. See [independent resources in parallel tests](testing-examples/parallel-tests.md).
- Where supported, use `t.Setenv` and `t.Chdir` to change and restore process state. Neither can be used in a parallel test or with a parallel ancestor. On older Go versions, restore state explicitly and preserve the same isolation requirement.
- When closures capture loop variables, follow the module's language version. Go 1.22 gives variables declared by a loop separate instances per iteration.

### Synchronization and goroutine failures

- Synchronize on the needed event with a bounded wait, as in [the worker-result example](testing-examples/goroutine-errors.md). An arbitrary sleep does not establish that the event happened.
- Call `Fatal` or `FailNow` from the test goroutine. Send worker failures back to that goroutine before failing the test.

## 5. Verify the result

### Run relevant checks

- Run the relevant focused tests, followed by the repository checks appropriate to the change.
- Use an uncached run when confirming execution matters, for example `go test -count=1 ./path/to/package`.
- Use the race detector for relevant shared-state changes on a supported platform. Expand testing when changed dependencies, failures, or unresolved risks justify it.
- For a regression, [demonstrate failure on the original fault and success with the fix](testing-examples/regression-verification.md#verify) when practical. Use an isolated check or a reversible local change that preserves unrelated work.

### Completion and reporting

- Finish when the selected behavior has an appropriate check, expectations have an independent basis, resources have cleanup, and applicable verification passes.
- Report commands and outcomes, failure output, skipped checks or prerequisites, and the limits of the evidence. See [the regression report](testing-examples/regression-verification.md#report).

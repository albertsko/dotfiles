# Tactical Programming

Keep intent visible, failures precise, and local changes easy to verify when implementing or reviewing code.

## Express intent

- Name roles and domain intent. Replace vague names such as `user` and `amount` with meaningful terms such as `buyer` and `discount`.
- Follow the language and project's vocabulary. Introduce explicit types when primitives hide units, ranges, or expectations.
- Treat difficulty naming something as a design signal. A name listing several jobs suggests separate responsibilities.
- Rename misleading names when their meaning changes. If renaming is difficult, examine the coupling that makes it difficult.
- Use comments for intent, constraints, tradeoffs, surprising choices, and assumptions that code cannot express.
- Improve unclear names or structure before explaining them in prose. Update or remove comments with the code they describe.

## Keep the main flow visible

- Check inputs, permissions, and stopping conditions as early as their required information becomes available.
- Exit when a stopping condition holds. Prefer `if (!isValid) return; doWork();` over wrapping the main work in `if (isValid)`.
- Remove a redundant `else` after a branch that returns or throws. Keep the main path flat so readers can release handled conditions.
- If deep nesting remains, look for a separate domain concept that deserves a named function.

## Keep related code together

- Organize by domain concept. Keep a type near its constructors, methods, and helpers instead of grouping all declarations by kind.
- Put primary types and entry points before implementation details, and common operations before specialized ones.
- Keep small helpers near their callers. Move shared helpers only as far as needed.
- Name files for domain concepts. If related code cannot stay reasonably close, reconsider the boundaries or split the file.
- Follow the surrounding package's convention when multiple orders are equally clear.

## Define contracts and enforce invariants

A precondition is the caller's duty. A postcondition is the routine's guarantee. An invariant is a fact that valid state preserves.

- Define valid inputs, guarantees, and deliberate non-guarantees before implementing. Promise only what the routine can reliably deliver.
- Make semantic invariants prominent and keep changeable policy separate. Restrict direct mutation of data participating in invariants.
- Treat internal contract violations as bugs. Handle invalid user input and expected operational errors through normal error paths.
- Without native contracts, combine assertions, guard clauses, and tests. Fail near the violation with precise diagnostics.
- Assert supposedly impossible states, internal parameters, results, and algorithm postconditions. Include useful diagnostic data.
- Keep assertion conditions free of side effects. Store the result of a state-changing operation before asserting about it.
- Keep invariant checks active in production, using explicit runtime checks where the language disables assertions. Disable individual diagnostics only for measured cost.

## Handle errors without hiding broken state

- Read the actual error and reassess assumptions about valid state. Recover only when the handler can restore or preserve that state.
- Make case analysis exhaustive. Use compiler-checked exhaustiveness where available; otherwise reject unexpected cases explicitly.
- Let exceptions propagate unless a handler can recover, translate a boundary error, or add useful context. Avoid catches that only log and rethrow.
- Stop the affected operation on an impossible state. Release resources and close transactions as required before termination.
- Where resilience requires restart, isolate fallible work under a supervisor instead of continuing with untrusted state.

## Verify assumptions

- Make relevant assumptions about locale, clocks, permissions, network availability, configuration, and execution order explicit and testable.
- Assert internal assumptions. Treat variable environmental failures as operational errors rather than impossible states.
- Use Coordinated Universal Time (UTC) for cross-zone instants while preserving domain requirements for local civil time.
- Recheck copied solutions in the current environment. A working example does not establish that its assumptions hold here.

## Balance resources

- Give the allocating code responsibility for cleanup unless it explicitly transfers ownership. Keep resource lifetimes narrow.
- Use scope-bound cleanup, such as `with`, `defer`, or deterministic destructors, or use `finally`. Clean up only resources successfully acquired.
- Acquire shared resource sets in a consistent order across callers, and release them in reverse to avoid deadlocks.
- Choose one cleanup policy per aggregate: release children recursively, release only itself, or refuse cleanup while populated.
- Bound long-lived logs, caches, and records through rotation, expiration, or another explicit retention policy.

## Protect external boundaries

- Minimize entry points and grant only the permissions needed, for only as long as needed. Prefer secure defaults with explicit opt-out.
- Validate external input at the boundary. Use context-appropriate sanitization or encoding before storing, rendering, or executing it.
- Return only authorized data. Remove default and unused credentials, and keep stack traces and debug facilities out of public responses.
- Encrypt sensitive data at rest. Keep secrets out of version control and supply them through protected deployment configuration or environment variables.
- Use vetted, maintained cryptographic libraries rather than implementing cryptography.

## Refactor and test the contract

- Address duplication, awkward code, rippling changes, and outdated assumptions within the authorized scope as understanding improves.
- Keep behavior-preserving refactoring distinguishable from behavior changes. Prefer small edits that let verification failures point to a specific change.
- Complete each refactoring step when the relevant checks that passed before the edit still pass afterward.
- Name work that cannot be changed incrementally as a rewrite so its scope remains explicit.
- Think through how a caller would test the contract before hardening an interface. Pass dependencies explicitly when hidden state obstructs testing.
- For test-driven development (TDD), confirm a test fails for the intended reason, implement the minimum, then refactor with tests passing.
- Select normal, boundary, invalid, and contrived cases that test meaningful behavior. Check both the implementation and the intended contract.
- Verify dependency behavior when it determines the result, so failures can be localized.
- Turn useful debugging reproductions into regression tests. Provide test access through structured logs or diagnostic switches where needed.
- Keep the suite passing. Routine failures train readers to ignore regressions. Avoid redundant tests and incidental assertions unless the contract requires them.
- When generated inputs can challenge assumptions, express contracts and invariants as properties with composable generators over broad input ranges.
- Check properties of results and state alongside clear examples. Capture exact failing inputs and retain a focused regression case after fixing the assumption.

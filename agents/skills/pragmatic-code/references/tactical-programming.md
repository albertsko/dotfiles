# Tactical programming

Implementation: make intent, contracts, failure paths, and resource ownership visible.

## Naming, comments, and organization

Use domain terms that name roles and intent. Follow project vocabulary and language conventions. Introduce explicit types when primitives obscure units or constraints. Rename misleading identifiers.

Use comments for rationale, constraints, and assumptions that code cannot express. Keep them consistent with changes. Improve unclear names or structure before adding explanatory prose.

Keep related types, operations, and small helpers near each other. Put entry points before supporting details when project conventions allow. Organize around concepts rather than generic collections of helpers or declarations.

## Guards and errors

Define valid inputs, guarantees, and invariants before implementing. Use guard clauses to handle invalid inputs and stopping conditions early, keeping the main flow readable. Remove redundant nesting after a return or throw. Extract a nested block when it represents a distinct concept.

Preserve validation order, side effects, error behavior, and cleanup when flattening control flow.

Handle expected errors and invalid external input through normal error paths. Use side-effect-free assertions for internal invariants. Fail at a violated invariant with useful diagnostics instead of continuing with invalid state.

Catch errors when the handler can recover, translate them at a boundary, or perform required cleanup. Otherwise let them propagate. Keep environmental assumptions explicit when behavior depends on them.

## Resource lifetimes and shared state

Give the allocating code responsibility for cleanup unless ownership is explicitly transferred. Keep lifetimes narrow. Use scope-bound cleanup or `finally` so returns and exceptions release acquired resources. Failed or partial acquisition must release only what was acquired.

For shared resources, make dependent checks and updates atomic. Keep locking within the resource's interface and release locks on every path. Acquire multiple locks in a consistent order. Use a transaction when several updates must succeed or fail together.

## Meaningful verification

Choose the narrowest useful check for the change. For non-trivial logic, leave a runnable test, self-check, or command that fails when the logic breaks. Trivial one-line changes need no new test. Run applicable checks when tools allow and report any unverified behavior.

Test observable contracts through real code paths: normal behavior, relevant boundaries, invalid inputs, and meaningful failures. For cleanup or error changes, exercise the affected exit paths. Test expectations should express intended behavior rather than reproduce the implementation.

Mock or fake external boundaries when needed. Prefer small fakes over broad mocks. Keep the code under test real. Each check needs an assertion that detects a relevant failure; coverage counts and assertion-free smoke tests do not provide that evidence.

Use focused regression checks for bugs. Property-based tests can probe broad input ranges when invariants are clearer than individual examples. Make refactoring incremental, preserve behavior, and use relevant checks to detect accidental changes.

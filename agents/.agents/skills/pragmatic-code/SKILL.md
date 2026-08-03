---
name: pragmatic-code
description: Practical guidelines, best practices, and decision workflows for pragmatic software engineering, clean code design, error handling, refactoring, and state management. Use whenever writing, reviewing, refactoring, or designing code to follow pragmatic programmer principles.
disable-model-invocation: true
---

# Pragmatic Code Skill

This skill provides actionable guidelines, decision workflows, and technical standards for writing clean, resilient, decoupled, and maintainable software based on _The Pragmatic Programmer_ principles.

## Core Directives

1. **Easier to Change (ETC)**: Evaluate every architectural and code modification by whether it makes future change easier or harder.
2. **Don't Repeat Yourself (DRY)**: Ensure every piece of knowledge or business intent has one unambiguous, authoritative representation in the system.
3. **Design by Contract (DbC)**: State routine preconditions, postconditions, and invariants explicitly. Reject invalid inputs at system boundaries and fail fast.
4. **Decouple Early & Often**: Keep components shy. Avoid train-wreck call chains (`a.b().c()`), eliminate global state, and write against application-owned abstractions.
5. **Program Deliberately**: Avoid programming by coincidence. Base code on documented guarantees, test assumptions, and address root causes rather than patching symptoms.

## Code Execution Workflow

When writing, editing, or refactoring code, execute the following workflow:

### Design & Scope

- **Small Slices**: Implement the smallest end-to-end slice that delivers observable behavior (tracer bullets).
- **Provisional Decisions**: Isolate 3rd-party dependencies, databases, and frameworks behind application-owned interfaces so choices remain reversible.
- **Pure Pipelines**: Design data transformations as composable, stateless pipelines (`Input -> Stage1 -> Stage2 -> Output`).

### Write & Defend

- **Contract Enforcement**: Validate untrusted inputs at entry boundaries. Require callers to satisfy preconditions and guarantee postconditions upon exit.
- **Fail Fast**: Do not swallow exceptions or return corrupted default states. Catch errors only to recover cleanly or add actionable context.
- **Assert Invariants**: Place explicit assertions on critical internal states and postconditions. Ensure assertions are side-effect free.
- **Resource Balancing**: Ensure the allocating function or block is responsible for releasing the resource. Protect cleanup with auto-closing blocks (`try-finally`).
- **Security Defaults**: Sanitize all external data, enforce least privilege, and keep secrets strictly out of version control.

### Concurrency & State Management

- **Atomic Operations**: Replace check-then-act sequences with atomic operations. Encapsulate synchronization inside the resource interface.
- **Avoid Shared Mutable State**: Prefer immutability, isolated actor mailboxes, or message passing over shared locks.
- **Event-Driven Patterns**: Use Finite State Machines for state-dependent logic, Pub/Sub for asynchronous decoupling, and reactive streams for time-series events.

### Verify & Refactor

- **Test-Driven Design**: Use tests to define API contracts before implementation. Test stable behavior rather than internal details.
- **Property-Based Testing**: Validate invariant properties across generated inputs to uncover edge cases.
- **Disciplined Refactoring**: Separate structural edits from feature additions. Execute small, test-verified refactoring steps.
- **Root-Cause Debugging**: Reproduce errors with a deterministic test first. Bisect state or revisions to fix the root cause near its origin.

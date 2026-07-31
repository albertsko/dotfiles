## Topic 23: Design by Contract

Design by Contract (DBC) establishes formal rights and responsibilities between calling code and software routines to guarantee program correctness. Developed by Bertrand Meyer, Design by Contract (DBC) requires both parties to agree on program state before and after execution.

Every routine contract relies on three core elements:

- **Preconditions**: Requirements that the caller must satisfy before calling a routine.
- **Postconditions**: Guarantees that the routine must fulfill upon completion.
- **Class Invariants**: State conditions that a module guarantees remain true whenever control returns to a caller.

If either party violates contract terms, the system invokes a remedy such as raising an exception or terminating the program. Contract violations signal software bugs rather than normal runtime exceptions.

### The Pragmatic Approach

Pragmatic programmers write lazy code by being strict about acceptable inputs and promising minimal outputs. Shifting input validation burden to the caller simplifies routine logic and prevents redundant defensive checks.

Implement Design by Contract through these practices:

- **Enforce preconditions at the boundary**: Require callers to pass valid data before executing routine logic.
- **Crash early**: Terminate execution immediately when contract assertions fail to prevent corrupt state from propagating.
- **Define semantic invariants**: Document inviolate business rules that define core system behavior regardless of policy changes.
- **Use language features or assertions**: Apply built-in contract specs, guard clauses, or runtime assertions to verify contracts automatically.

### Common Mistakes

- **Using preconditions for input validation**: Passing bad user input into a contract instead of validating user data at system boundaries.
- **Overpromising routine results**: Writing contracts that accept any input and promise wide-ranging return guarantees.
- **Assuming assertions equal native contracts**: Relying on basic assertions while neglecting contract inheritance, previous-state tracking, and library boundaries.
- **Confusing business policies with semantic invariants**: Treating temporary management rules as inviolate system laws.

## 23. Design by Contract

Design by Contract (DBC) specifies the rights and responsibilities at each software boundary so a routine does no more and no less than it claims. Preconditions define what callers must make true before invocation, postconditions define what the routine guarantees upon termination, and invariants define the state callers can rely on before and after an operation even when internal processing temporarily breaks it. Invariants apply to state in any programming paradigm, not only to objects and classes. When a caller satisfies the preconditions, the routine must terminate with its postconditions and invariants restored; any violation is a bug that should trigger an agreed remedy, such as an exception or program termination, rather than serve as ordinary user-input validation. DBC complements testing by defining success and failure for every execution, checking internal state throughout the software lifecycle, and assigning each validation responsibility once. Native contract support provides the strongest enforcement, while assertions, guard clauses, comments, and tests can preserve much of the design value but may require manual handling of inheritance, prior values, invariant checks, and library boundaries. Semantic invariants capture unchanging requirements that guide the whole system, while autonomous agents may use dynamic contracts to reject or renegotiate requests without abandoning explicit obligations and guarantees.

### The Pragmatic Approach

- Define each routine's valid input domain, boundary conditions, guarantees, and deliberate non-guarantees before writing its implementation.
- State preconditions for callers, postconditions for successful completion, and invariants for externally observable state.
- Require callers to validate external input and invoke routines only after satisfying their preconditions.
- Restrict direct mutation of data that participates in an invariant.
- Accept only clearly valid inputs and promise only what the routine can reliably deliver.
- Enforce contracts with native language features when available; otherwise use guards, assertions, comments, or tests and preserve any entry-state values needed by postconditions.
- Treat every contract violation as a bug and fail at the point of violation with precise diagnostic information.
- Use contracts alongside tests instead of expecting individual test cases to define every valid behavior or protect every internal invariant.
- Identify requirements that define the system's meaning, state them clearly as semantic invariants, and keep changeable policies separate.
- Make negotiated agent contracts explicit about which requests may be rejected, which obligations may change, and which guarantees remain in force.

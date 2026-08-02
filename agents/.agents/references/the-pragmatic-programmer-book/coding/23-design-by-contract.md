## 23. Design by Contract

Design by Contract (DBC) makes each software component state exactly what it requires and guarantees. A routine's contract defines the preconditions its caller must satisfy, the postconditions the routine must establish when it terminates, and the invariants that must hold whenever control returns to a caller. A fulfilled precondition obligates the routine to satisfy its postconditions and restore its invariants; any violation is a bug that should fail immediately with a precise diagnostic. Contracts complement tests by defining correctness for every execution, including internal state constraints, while tests demonstrate selected cases.

### The Pragmatic Approach

- Define the contract before implementing a routine: list the valid input domain, boundary conditions, required state, promised result, state changes, and explicit non-guarantees.
- Make callers satisfy preconditions. Validate untrusted or user-provided data at the system boundary, then call contracted routines only with valid values; for example, reject or transform a negative value before calling a square-root routine that requires a nonnegative argument.
- Accept only the inputs the routine can handle correctly and promise only the outcomes callers truly need. Smaller contracts reduce implementation complexity and future compatibility obligations.
- State postconditions as observable facts. For example, a deposit routine may guarantee that its returned transaction identifier appears in the specified account's transactions.
- Protect invariants through encapsulation. Allow temporary internal inconsistency only while a routine runs, restore every invariant before returning, and prevent unrestricted writes to state involved in an invariant.
- Express state invariants even outside object-oriented code. When functions receive state and return updated state, require the input state to be valid and guarantee that the returned state preserves the same essential rules.
- Prefer language-supported contracts, specifications, guard clauses, or constrained dispatch that make invalid calls impossible. Use assertions, preambles, postambles, comments, or tests when native support is unavailable, while accounting for disabled checks, overridden methods, inherited invariants, and values that must be captured on entry for later comparison.
- Enforce contracts at integration boundaries as well as inside application code. Wrap unchecked libraries or external components when their assumptions and guarantees would otherwise remain implicit.
- Fail at the point of a contract violation with the violated condition and relevant context. Do not let an invalid sentinel value or corrupted state travel through the system and obscure the original defect.
- Keep contracts alongside tests. Use contracts to enforce all-call requirements and internal invariants, and use unit, test-driven, and property-based testing to exercise behavior across representative and generated cases.
- Identify semantic invariants that define the system's meaning, state them clearly, and use them to resolve failure and recovery choices. Separate permanent guarantees, such as never applying one debit twice, from business policies that may change.
- Make contracts explicit for autonomous or dynamic components. Permit a component to reject an unacceptable request or renegotiate its obligations rather than silently accepting terms it cannot satisfy.

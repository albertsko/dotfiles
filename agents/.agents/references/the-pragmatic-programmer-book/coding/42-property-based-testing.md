## 42. Property-Based Testing

Property-based testing validates contracts and invariants across many generated inputs, reducing the chance that production code and handpicked unit tests encode the same faulty assumption. Instead of enumerating cases, define what must always be true, such as sorting preserving a list's length and ordering every element before its successor, then let a testing framework generate varied and composable data. A failure may reveal a violated assertion or an inability to handle valid input, and the falsifying values provide a focused path to diagnosis. Property-based tests complement example-based unit tests and improve design by forcing APIs and state transitions to express their guarantees clearly.

### The Pragmatic Approach

- Identify each operation's preconditions, postconditions, and invariants before choosing test examples.
- Express properties independently of the implementation. For example, assert that a successful stock removal leaves `remaining quantity + removed quantity == original quantity`.
- Describe generated data precisely: constrain values to the relevant ranges, transform generators when the domain requires it, and compose generators for collections and related values. Include empty collections, minimum and maximum values, and values on both sides of important boundaries.
- Generate combinations that challenge assumptions shared by the code and its unit tests. For example, test requests both below and above the available stock instead of checking only whether any stock exists.
- Treat unexpected exceptions from valid generated inputs as property failures, even when the declared assertion did not fail.
- Inspect the reported falsifying input, reproduce it in a focused unit test, and keep that test as a deterministic regression check because later generated runs may use different values.
- Fix the violated contract or data model, not merely the observed example. If availability depends on quantity, make quantity part of the availability check.
- Keep focused unit tests for known behavior and regressions, and use property-based tests to explore broad input spaces and validate universal guarantees.
- Use difficult-to-state properties as design feedback: simplify APIs and state transitions until their invariants are explicit and testable.

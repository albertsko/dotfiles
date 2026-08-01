## 25. Assertive Programming

Treat claims that a state “can never happen” as assumptions to verify with assertions, which expose bugs and unexpected environmental failures close to their origin. Use assertions for violated invariants and algorithm postconditions, not for invalid user input or recoverable failures that require normal error handling. Keep assertion conditions free of side effects so checks cannot change the behavior they observe. Leave assertions enabled in production because tests cannot cover every execution and production introduces failures absent from test environments; disable only individual checks whose measured cost is unacceptable.

### The Pragmatic Approach

- Add an assertion whenever code depends on a supposedly impossible state.
- Check invariants, parameters, results, and algorithm postconditions explicitly.
- Include descriptive failure messages and relevant diagnostic data.
- Handle expected errors and invalid input with normal error-handling code.
- Evaluate state-changing operations separately, then assert against their stored results.
- Release resources safely after an assertion failure without relying on suspect state.
- Keep assertions enabled in production, and make only demonstrably expensive checks optional.

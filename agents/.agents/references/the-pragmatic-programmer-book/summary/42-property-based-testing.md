## 42. Property-Based Testing

Example-based unit tests can repeat the same mistaken assumptions embedded in the code, so passing tests do not prove that the assumptions are correct. Property-based testing reduces that blind spot by generating many varied inputs and checking properties: contracts that specify valid inputs and guaranteed outputs, plus invariants that must remain true as state changes. Composable data generators can explore cases the programmer did not anticipate, exposing failed assertions, unhandled inputs, or defects outside the behavior under direct test, such as accepting an order when some stock exists but not enough to fill the requested quantity. Because generated failures can be difficult to isolate and may not recur with the same values, preserve each failing case as a focused unit test; defining the properties also improves design by revealing edge cases and inconsistent state, making property-based tests a complement to unit tests.

### The Pragmatic Approach

- Identify the contracts and invariants that express what must be true before and after each operation.
- Describe broad, relevant input sets with composable generators, including boundary values and varied collection sizes.
- Assert properties of the results and state changes instead of checking only a few expected examples.
- Run generated cases to challenge assumptions shared by the implementation and its conventional unit tests.
- Capture the exact inputs from every failure, reproduce them in a focused unit test, fix the faulty assumption, and keep the test as a regression guard.
- Use property-based tests alongside unit tests to validate general behavior while preserving clear examples of known cases.

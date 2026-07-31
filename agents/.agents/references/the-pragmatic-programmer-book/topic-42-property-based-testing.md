## Topic 42: Property-Based Testing

Unit tests written by the same developer who wrote the code risk encoding the same false assumptions. Property-based testing solves this by using automated data generation to validate code against contracts and invariants. Instead of testing specific inputs and expected outputs, developers define universal properties that must hold true for all valid inputs. Testing frameworks then execute functions against hundreds of randomly generated inputs, exposing edge cases and unexpected failures that manual tests miss.

### The Pragmatic Approach

- Define code invariants and contracts as properties, such as ensuring a sorted list retains its original length and element order.
- Use property-based testing frameworks to generate diverse, random test datasets automatically.
- Convert failing generated test cases into explicit, deterministic unit tests to serve as permanent regression tests.
- Use property definitions during design to clarify boundary conditions, data invariants, and output guarantees.
- Combine property-based testing with traditional unit testing to achieve complete code coverage and contract verification.

### Common Mistakes

- Relying solely on hand-crafted unit tests, which share the developer's blind spots and preconceptions.
- Assuming a passing unit test guarantees correct business logic across all edge cases.
- Failing to capture random property test failures into deterministic regression tests, allowing transient bugs to resurface.
- Treating property-based testing as a replacement for unit testing rather than a complementary technique.
- Over-specifying test data generators instead of letting the framework test unpredictable inputs.

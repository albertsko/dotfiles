## 41. Test to Code

Testing delivers its greatest benefit while you think about and write tests, because a test is the first user of the code and exposes unclear requirements, awkward interfaces, hidden dependencies, boundary conditions, and error cases before implementation hardens them. Designing for testability reduces coupling and increases flexibility by making dependencies and variable behavior explicit. Test-driven development (TDD) turns that thinking into a short cycle: choose a small behavior, write a failing test, run all tests and confirm that the new test is the only failure, add the least code needed, then refactor while keeping every test green. TDD ensures that tests exist, but chasing 100% coverage, retaining redundant tests, and following passing-test momentum can distract from solving the actual problem. Neither top-down nor bottom-up design handles initial uncertainty well: one assumes complete requirements, while the other assumes useful abstractions can be chosen without knowing the destination. Build small pieces of end-to-end functionality, learn from each piece, involve the customer, and keep the destination and overall design in view. Test each unit in isolation against its contract, including preconditions, promised results, boundary values, and error conditions; this checks both whether the code honors the contract and whether the contract means what you intended. Verify dependencies first so failures narrow the likely fault, then reuse test facilities to exercise the integrated system. Build test access into software through consistent, parseable logs and controlled diagnostics for deployed systems, and convert useful ad hoc checks into permanent regression tests. Test-aware design can make code testable, but it does not make the code tested. Written tests also communicate expected behavior to other developers, particularly in shared code and code that relies on external dependencies. Treat testing as part of programming: test first when practical, test during development when necessary, keep all tests passing so routine failures do not train the team to ignore the suite, and maintain test code with the same care as production code.

### The Pragmatic Approach

- Think through tests before implementation to clarify behavior, boundaries, and failures.
- Pass dependencies into code instead of hiding them in global state.
- Let tests shape small, flexible interfaces without losing sight of the intended outcome.
- Use a short TDD cycle: add one failing test, run all tests and confirm that it is the only failure, implement the minimum behavior, and refactor with all tests passing.
- Avoid chasing 100% coverage or retaining tests made redundant by later tests.
- Build and review end-to-end increments with the customer as the problem becomes clearer.
- Test every unit against its contract under normal, boundary, invalid, and contrived conditions.
- Verify both that the code honors its contract and that the contract expresses the intended behavior.
- Verify lower-level dependencies before testing code that relies on them.
- Check results against known values or trusted results from previous runs.
- Reuse unit-test facilities to exercise the integrated system.
- Preserve every useful debugging check as an automated regression test.
- Expose controlled production diagnostics through structured logs, diagnostic views, or feature switches.
- Use tests to communicate expected behavior to collaborators.
- Keep the entire test suite reliable, clean, decoupled, and green.
- Avoid fragile assertions based on incidental details such as exact timestamps, widget positions, or error wording.
- Test first or during development; never postpone testing until users find the failures.

## 41. Test to Code

Testing is a design activity whose greatest value comes from forcing engineers to understand a unit's contract, boundary conditions, error behavior, dependencies, and public interface before or during implementation. Treat a test as the code's first user: difficult setup exposes coupling, while controlled dependencies and explicit parameters produce flexible, observable components. Use short test-driven cycles when useful, but guide them with an end-to-end destination and customer feedback so passing tests advance the actual solution instead of rewarding local polish. Verify each unit against its contract, preserve every discovered failure as a regression test, expose safe diagnostics for deployed code, and keep tests as clean and reliable as production code. A healthy testing culture keeps the suite passing continuously because testing, design, and coding form one engineering activity.

### The Pragmatic Approach

- Define each unit's contract before implementing it: state accepted inputs, rejected inputs, promised results, boundary behavior, and error behavior.
- Design from the caller's perspective by writing or imagining the first test before the implementation. If a query needs a controllable database, accept the database as a parameter instead of reading a global connection.
- Make dependencies replaceable and internal state observable through explicit interfaces. Treat extensive test setup as evidence that the unit has excessive coupling.
- Build small end-to-end slices that deliver observable behavior, then use what you learn and customer feedback to choose the next slice.
- Keep each test-driven development cycle to minutes: select one behavior, write a test that fails for the expected reason, implement the smallest useful change, run the full suite, and refactor while the suite stays green.
- Maintain a destination beyond the next passing test. Reassess whether each cycle advances the real solution, especially when representation details or easy cases consume repeated effort.
- Test units in dependency order. Verify each dependency's full contract first, then test the consuming unit's contract and its use of those dependencies.
- Derive cases from the contract rather than random examples. Cover valid ranges, boundary values, invalid inputs, promised outputs, and failures; for a square-root function, test zero, representative positive values, large values, acceptable numerical error, and rejection of negatives.
- Convert every useful console experiment, debugger probe, or manual reproduction into an automated regression test after debugging.
- Provide a safe production test window with consistent, machine-parseable logs and controlled diagnostic switches for selected users or requests.
- Test stable behavior instead of incidental details such as widget coordinates, exact timestamps, or error-message wording. Keep test code clean, decoupled, deterministic, and maintainable.
- Keep all tests passing. Fix or remove tests that always fail, delete redundant tests, and pursue meaningful risk coverage instead of treating 100% coverage as the goal.
- Test first when practical and test during implementation when necessary. Never defer testing to an unspecified later phase.

## 40. Refactoring

Refactoring is disciplined, day-to-day redesign that improves code's internal structure without changing its external behavior. Use it to keep code easy to change as understanding, requirements, usage, and performance needs evolve, and to remove duplication, oversized responsibilities, misplaced functionality, and unnecessary coupling. Refactor early in small, low-risk steps backed by automated tests, because postponing structural problems lets dependencies accumulate until a simple correction becomes an expensive rewrite.

### The Pragmatic Approach

- Separate structural improvements from feature work so each change has one purpose and failures have a narrow cause.
- Protect current behavior with automated unit and regression tests before changing the structure.
- Refactor as soon as new knowledge exposes duplication, awkward dependencies, outdated assumptions, overloaded routines, or misplaced responsibilities.
- Take one deliberate, localized step at a time, such as renaming a variable, extracting part of a long method, or moving a field to the class that owns it.
- Run the relevant tests after every step and stop to fix a failure before making another change.
- Refactor immediately after a new test passes, while the code and its intended behavior are fresh and protected.
- Use automated refactoring tools for operations such as renaming, extracting methods, and moving code, then verify their results with tests.
- Schedule a rewrite explicitly when the required change is too large for incremental refactoring, and tell affected users how the rewrite may impact them.
- Make incompatible interface changes fail at compile time when external behavior must change, so every client that requires an update becomes visible.

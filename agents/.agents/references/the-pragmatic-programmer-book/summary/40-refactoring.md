## 40. Refactoring

Software evolves more like a garden than a finished building: as knowledge, requirements, usage, and performance needs change, code must be pruned, moved, split, or simplified. Refactoring is disciplined restructuring that improves internal design without changing external behavior, and it works best as routine, precise maintenance rather than a wholesale rewrite. Refactor when duplication, unnecessary coupling, outdated knowledge, real-world usage, performance needs, or newly passing tests reveal a better structure, because postponement allows dependencies, cost, and risk to grow. Good automated tests, frequent test runs, small deliberate changes, and strict separation from feature work keep refactoring safe; changing external behavior or interfaces goes beyond refactoring.

### The Pragmatic Approach

- Refactor as soon as new knowledge or awkward code reveals a better design.
- Keep refactoring separate from adding features or changing behavior.
- Establish automated unit and regression tests before restructuring code.
- Make one small, deliberate change at a time, such as renaming a variable, moving a field, or splitting a routine.
- Run the tests after each change so failures identify a small, recent edit.
- Use automated refactoring tools to propagate safe structural changes when available.
- Schedule a rewrite explicitly when the required change is too disruptive for incremental refactoring, and inform affected users.
- Make old clients fail to compile when an intentional interface change must expose every dependency that needs updating.

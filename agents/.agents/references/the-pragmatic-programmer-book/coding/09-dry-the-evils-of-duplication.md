## 9. DRY, The Evils of Duplication

Software development is continuous maintenance because requirements, regulations, environments, algorithms, and engineers' understanding keep changing. The Don't Repeat Yourself (DRY) principle requires every piece of knowledge or intent to have one unambiguous, authoritative representation, so a change happens in one place and cannot leave contradictory versions behind. DRY applies to code, documentation, derived data, interface contracts, and knowledge distributed among developers; identical code violates DRY only when it represents the same knowledge, not when unrelated rules happen to match. Duplication at external boundaries or for performance may be unavoidable, but engineers should generate or validate representations from one source and encapsulate cached derivatives so one module maintains consistency.

### The Pragmatic Approach

- Identify knowledge duplication by asking whether one business or technical decision requires changes in multiple places or formats; if changing a fee requires edits to code, comments, and tests that restate the calculation, establish one authoritative representation.
- Extract repeated intent into focused abstractions. For example, centralize amount formatting and report-line layout in separate functions so each formatting rule changes once.
- Keep distinct domain concepts separate when their implementations merely coincide. Preserve separate age and quantity validators when both currently require positive integers, because either rule can evolve independently.
- Make code communicate its behavior through precise names and clear structure. Use comments to add information the code cannot express instead of repeating the implementation in prose.
- Derive values from their authoritative inputs instead of storing redundant state. Compute a line's length from its endpoints; when performance requires caching the length, keep the cache private and refresh it through every endpoint mutation.
- Hide storage choices behind accessors so callers use the same interface whether a value is stored or computed. This containment lets the owning module change its implementation without spreading duplicated knowledge.
- Define each internal interface in a neutral, central specification, then generate clients, documentation, mocks, and functional tests from it. Import a formal external interface specification when one exists, or create and maintain one when it does not.
- Derive data containers from introspected schemas instead of copying schemas into code by hand. When using flexible key/value structures, add table-driven validation that checks the required fields and formats.
- Search for existing utilities before implementing shared functionality, place reusable code where the team can find it, and surface overlapping work through frequent communication, code reviews, and reading teammates' code.

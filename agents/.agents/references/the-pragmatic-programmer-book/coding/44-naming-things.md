## 44. Naming Things

Names carry design intent across applications, modules, functions, types, parameters, and variables, so name each element for the role it plays in the domain rather than its implementation mechanics. Finding a precise name exposes unclear responsibilities, invalid abstractions, and ambiguous data contracts, while consistent project vocabulary and language conventions reduce cognitive load. Because responsibilities evolve, treat misleading names as defects and keep the code easy to rename.

### The Pragmatic Approach

- Pause before creating an element and identify its role, motivation, capabilities, and collaborators; reconsider the design when no accurate name emerges.
- Prefer clear, domain-specific roles over generic or clever labels: use `buyer` or `customer` instead of `user` when the distinction affects behavior.
- Name operations for their intent rather than their mechanics: prefer `applyDiscount` over `deductPercent`.
- Encode ambiguous expectations in names and types: accept `Percentage discount` instead of `double amount` so callers know both the meaning and the valid representation.
- Read a name in its calling context and remove redundant repetition: prefer `Fib.nth(20)` over `Fib.fib(20)`.
- Follow the language and codebase conventions for casing, abbreviations, short variable names, and Unicode; use a single-letter loop variable only where readers expect that convention.
- Establish a shared project vocabulary, record specialized terms in a glossary, and reinforce them through frequent communication and collaboration so the team can use them as precise shorthand.
- Check that code names match the domain terms users and the team use; resolve mismatches that force readers to translate between competing vocabularies.
- Treat an overly generic name as a refactoring signal; rename it to describe its full responsibility, then split the element when the resulting name reveals multiple jobs.
- Rename an element as soon as its meaning changes or its name becomes confusing, and maintain regression tests so missed uses are detected.
- Treat a difficult rename as a design problem; fix the constraint that blocks the rename, then correct the name.

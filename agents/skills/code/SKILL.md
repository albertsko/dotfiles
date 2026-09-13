---
name: code
description: General coding guide, language-agnostic.
disable-model-invocation: true
---

# Code

## Coding Mindset

- Prefer existing abstractions over new abstractions.
- Prefer concrete code over speculative frameworks.
- Prefer deletion over indirection.
- Apply KISS unless correctness, security, accessibility, or requested scope requires more.
- Discover abstractions during implementation. Do not invent abstractions before implementation pressure proves a need.
- Comment the why, never the what: make code self-documenting through clear names, and comment only non-obvious rationale, tricky logic, or invariants the code cannot show.

## Testing

- Treat code without its check as unfinished.
- For non-trivial logic, leave one runnable check:
  - one focused unit test, or one integration test,
  - or one self-check script,
  - or one narrow command that fails when the logic breaks
- Skip tests for trivial one-liners.
- Use the narrowest useful check.
- Run the check when tools allow it.
- Test observable behavior, not implementation details.
- Prefer tests that exercise real code paths.
- Mock or fake only external boundaries.
- Prefer small fakes or in-memory adapters over broad mocks.
- Do not mock the function, class, or module under test.
- Do not add assertion-free smoke tests.
- Do not add tests that pass when the logic breaks.
- Do not chase coverage numbers with low-value tests.

---
name: pragmatic-code
description: "Use only on explicit pragmatic-code request for architecture or implementation guidance."
disable-model-invocation: true
---

# Pragmatic Code

**Easier to change** is the design criterion. When principles conflict, weigh what each protects against the actual change.

Prefer the simplest structure that meets correctness, security, accessibility, and requested scope. Reuse suitable existing abstractions. Let concrete implementation pressure justify new ones.

Read the reference for the decision at hand:

- For architecture, module boundaries, coupling, duplicated knowledge, vendor choices, or proposed abstractions, read [Strategic programming](references/strategic-programming.md).
- For implementation, naming, comments, guard clauses, code organization, errors, cleanup, or tests, read [Tactical programming](references/tactical-programming.md).

Here, strategic means architecture and tactical means implementation practices. Read both when the task involves both kinds of decisions.

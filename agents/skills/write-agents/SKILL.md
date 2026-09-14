---
name: write-agents
description: Write, review, and organize AGENTS.md, CLAUDE.md, skills, and agent reference documents.
disable-model-invocation: true
---

# Write Agents

Write agent documents that change decisions through verified facts, clear context pointers, and observable completion criteria.
Keep the user's scope and existing workflow, including its planning, approval, testing, and integration requirements.

## Choose the format

Read only the guides for the requested deliverables:

- **AGENTS.md or CLAUDE.md:** When creating, editing, reviewing, or restructuring repository context files, read [agents.md](references/agents.md).
- **SKILL.md:** When creating, editing, reviewing, or restructuring a skill and its metadata or resources, read [skill.md](references/skill.md).
- **Reference document:** When creating, editing, reviewing, or extracting instructions loaded through a context pointer, read [reference.md](references/reference.md).

## Write or revise

1. Read the target, its callers, and the source files that establish its rules. Account for every requested change and material existing instruction. Identify unsupported claims and missing evidence before rewriting them.
2. Place each instruction using the information hierarchy below. Every moved instruction needs a reachable home or a stated reason for removal.
3. Draft using the shared principles and selected format guide. Preserve the source's certainty, permissions, timing, and scope. Give procedural steps observable completion criteria that cover every required result.
4. Review the full result against the sources and request. Verify paths, commands, metadata, and pointer conditions. Report material behavior changes and any checks that remain unresolved.

## Context pointers

A context pointer names material outside the current document and states when to read it.
Its wording decides whether the agent reaches that material.

- Front-load the task, path, or decision that triggers reading. Give each distinct branch one trigger.
- Name the exact target with a Markdown link or backticked path. A topic label alone leaves the reading condition unclear.
- If relevant material is missed, sharpen its pointer first. Inline it when every branch needs it.

Example: `Before editing drizzle/migrations/, read .agents/references/db-migrations.md.`

## Information hierarchy

- **Inline steps:** Put the actions the agent needs now in execution order.
- **Inline reference:** Keep shared definitions, rules, and decision criteria beside the concept they explain.
- **Disclosed reference:** Move substantial branch-specific detail behind a context pointer.

Choose placement by when the material is needed, not a universal line limit.
Each extra entrypoint also costs the human another name to remember. Group related branches when one clear router serves them.

## Precision and pruning

- Prefer a positive action: "Use the shared `apiClient` from `lib/http`." Keep hard prohibitions where needed, with the supported alternative.
- Use exact commands, real paths, and verified versions when those details prevent mistakes. Mark illustrative examples as examples.
- Make completion checkable and exhaustive: "Every modified model has a migration or a documented reason it needs none."
- Use a stable term for each concept. Define an unfamiliar term once and reuse it instead of repeating its explanation.
- State conditions that resolve conflicting rules. Preserve a requirement as a requirement and a local preference as a preference.
- Keep each meaning in one source of truth. Prefer pointers to authoritative code or configuration over copies that can become stale.
- Retain facts the agent cannot cheaply discover: conventions, reasons, and recurring failure modes. Cache a lookup only when the saved work justifies maintenance.
- Remove repetition, generic advice, obsolete rules, and lines that do not change a decision. Move relevant conditional detail instead of deleting its meaning.
- Verify evidence before retaining statistics or platform claims. If evidence is missing, omit the claim or state the uncertainty and its reason.

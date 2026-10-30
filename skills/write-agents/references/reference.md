# Reference documents

Write focused guidance that an agent reaches through a context pointer when a particular task needs it.
Choose this format for conditional rules, decision tables, subsystem knowledge, failure modes, or debugging guidance.

## Scope and location

Keep one coherent concern in each document and state its scope in the opening line.
Split substantial independent branches when doing so shortens the path to the relevant guidance.

For a reference bundled with a skill, use that skill's `references/` directory.
For a repository-level reference, use the repository's existing shared reference location.
If none exists, `.agents/references/` or `docs/agents/` are example choices. Choose one that fits the repository.
Name files after their concern, such as `db-migrations.md`, so a pointer communicates its target clearly.

Before using a tool-specific directory or configuration entry, verify whether it loads content automatically.
Paths such as `.claude/rules/` and `instructions` entries in `opencode.json` require that check before treating them as conditional references.
Preserve shared source files and verified aliases when several tools need the same material.

## Link from the entrypoint

Give each reference a direct pointer from the entrypoint that governs its use, such as AGENTS.md, CLAUDE.md, or SKILL.md.
Keep the path one level deep so the agent can reach its guidance without following a chain of routing documents.
For an extraction, replace the original section with its pointer in the same change.

Example:

```markdown
Before creating or editing files in drizzle/migrations/, read [.agents/references/db-migrations.md](.agents/references/db-migrations.md).
```

Use a Markdown link or backticked path for conditional reading.
An import syntax such as bare `@path` can have different loading behavior. Verify it before using it as a pointer.

## Choose the right home

Keep facts every task in a scope needs in its context file.
Use a skill when the task needs a separately invoked capability or reusable workflow.
A reference can contain supporting steps. Choose its home by reach and reuse, not a blanket distinction between "read" and "follow".

## Verify the extraction

- Confirm the pointer's path resolves from its caller and its condition covers every intended task branch.
- Account for every material rule from the original section in the reference or remaining inline guidance.
- Confirm that moved guidance has one authoritative home and surrounding text still makes sense.
- If a reference is unused, inspect its callers and purpose before changing its trigger or removing it.
- Update the document and its pointer together when scope or conventions change.

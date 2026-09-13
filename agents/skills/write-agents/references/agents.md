# AGENTS.md and CLAUDE.md

Write repository context for the scope where the target tool loads it.
Inspect existing instruction files and tool configuration before changing their placement or inheritance.

## Keep useful context

Retain non-obvious facts that affect work across tasks in this scope:

- Commands the agent would otherwise guess wrong, including relevant working directories and prerequisites.
- Conventions that differ from language or framework defaults.
- Authorized boundaries, approval requirements, and prohibited operations already established by the user or repository.
- Branch, commit, and pull request conventions when the repository actually requires them.
- Environment quirks, required variables, and recurring failure modes absent from ordinary configuration.
- Context pointers to task-specific skills and references, with a distinct reading condition for each.

Put consequential constraints before secondary background.
Keep the file focused enough that routine tasks can find their rules without reading unrelated inventories.
Move conditional detail by branch, even when the file is still short.

Prefer the authoritative source for package versions, scripts, API details, and directory contents.
Include a brief layout only when ownership or connections are otherwise difficult to infer.
Use a short production example or decision table when it makes a local convention clearer than prose.

## Scope in a monorepo

Keep shared conventions at the root and package-specific instructions near their package, where supported by the target tools.
Before relying on a nested file, verify how each supported tool discovers and combines instructions.
Use explicit scope when rules differ between packages. Keep ownership and maintenance with the relevant package.

## Tool interoperability

Keep shared instructions in one source and preserve verified aliases or imports used by the repository.
Confirm target paths and loader behavior before introducing a new tool-specific entrypoint.
Check existing files before creating aliases so a tool-specific addition is preserved.

For a setup using `AGENTS.md` as its shared source, these are example aliases:

```sh
# From the repository root, after confirming both link names are unused:
ln -s AGENTS.md CLAUDE.md
# Requires .claude/ and .agents/skills to exist:
ln -s ../.agents/skills .claude/skills
```

When separate tool-specific additions are needed, use a supported import mechanism and keep shared content in its original file.
An `@AGENTS.md` import is a different mechanism from a conditional reference link. Verify that the target tool supports it.
Use the repository's supported local-only file and ignore convention for personal instructions.
Where an invariant requires mechanical enforcement, identify the existing hook or check that enforces it.

## Review and maintenance

- Verify literal commands against their definitions, including working directory, flags, and required versions.
- Confirm each pointer resolves and names the task that needs its target.
- Check scope and precedence in the actual tool setup rather than assuming a universal "nearest file wins" rule.
- Update affected instructions alongside a convention change. Add a rule when a demonstrated mistake reveals missing context.
- Check nearby documents for conflicting or obsolete guidance when restructuring context. Keep cleanup within the authorized scope.

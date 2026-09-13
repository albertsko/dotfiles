# Repository Instructions

Use this reference for AGENTS.md, CLAUDE.md, and repository-level instruction placement.

## Select Content

Inspect the current instructions and the relevant code, configuration, and documentation before editing. Keep repository-specific decisions agents would otherwise get wrong:

- Non-obvious environment prerequisites and their effects.
- Local exceptions to usual language, framework, or repository conventions.
- Supported commands whose required options or execution context are easy to miss.
- Established ownership, authorization boundaries, and contribution requirements relevant to the work.

Let manifests and existing documentation supply ordinary package identity, package-manager selection, and standard script definitions. Preserve each verification obligation by naming the required checks, their success condition, and the canonical source of their commands. Inline command text when a local exception changes how to run it, such as an undocumented environment setting. If the user requires exact commands in the document, include them as requested.

Place broadly applicable repository rules in the root instructions. Place package-only rules in scoped instructions when the target runtime supports that scope. For detail needed only by particular tasks, create a conditional reference. For a reusable workflow that needs its own invocation, use a skill.

## Scope And Interoperability

Check the target runtime's current instruction discovery and precedence before depending on nested files, imports, or aliases. State local exceptions with their affected paths. Reconcile conflicts against applicable higher-priority instructions; file proximity alone does not establish universal precedence.

Keep shared instructions in a canonical file. When a tool-specific filename is needed, use a verified alias or supported import. Preserve existing files and tool-specific additions when arranging that connection. Verify the resolved target and intended loading behavior.

Use supported enforcement for mechanically mandatory rules when the task includes enforcement. Documenting a rule alone does not guarantee compliance.

## Check The Result

Account for each source instruction: retained, moved with a working pointer, or removed with a reason. Confirm commands, paths, prerequisites, and local exceptions against current evidence. Check the effective instructions for a root task and each affected package task.

Update guidance alongside the behavior it describes. Remove obsolete rules and broken pointers when discovered.

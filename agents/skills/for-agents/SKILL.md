---
name: for-agents
description: Use when creating, reviewing, or editing AGENTS.md, CLAUDE.md, agent skills, or reference documents intended for agents.
disable-model-invocation: true
---

# For Agents

Write instructions that change decisions and make completion checkable.

Read the matching references before drafting. A task can need more than one:

- For repository instructions and their scope, read [agents-md.md](references/agents-md.md).
- For skill authoring and invocation, read [skills.md](references/skills.md).
- For creating, extracting, editing, or reviewing on-demand reference documentation, read [reference-docs.md](references/reference-docs.md).

Preserve material facts, exceptions, uncertainty, and authorization from the source. Ground new requirements and commands in verified evidence.

Keep each meaning in one authoritative place. Use existing code, configuration, and documentation for cheap lookups; retain hard-to-discover conventions and gotchas.

State the desired action, with its condition first. Give each step an observable completion criterion. Group each concept's rules and caveats together.

Keep guidance needed by every branch inline. Link conditional detail with its topic and every distinct task that needs it, including review when applicable.

Finish when every material requirement has an authoritative home, links reach the intended detail, and the applicable reference's checks pass.

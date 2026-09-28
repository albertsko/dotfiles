---
name: flow
description: Software engineering workflow.
disable-model-invocation: true
---

# Flow

- For the coordinator only.
- A task is the main user request.
- A subtask is delegated work.
- Scale to uncertainty, dependencies, and consequences.

## Workflow

**Select host reference**

- Read [Codex](references/codex.md) or [Claude Code](references/claude.md) for the current host. If unknown, stop and ask.
- Honor explicit model and effort choices. Available models and tool definitions override reference examples.

**Set up**

- Work in a Git repository. Otherwise, stop and ask for next steps.
- Create one unique, descriptive `.scratch/{task-id}` directory per task. Reuse it across follow-up turns and all phases, including planning, implementation, verification, and review. Keep all task and subtask artifacts there. Exclude them from commits.
- When working cross repository, reuse the `{original-repo}/.scratch/{task-id}` directory.
- Record specification and details in the `.scratch/{task-id}/SPEC.md`, and plan in the `.scratch/{task-id}/PLAN.md`.

**Delegate to subagent**

- Delegate work when the benefits outweigh the cost of coordination. Count avoiding unnecessary context as a benefit. Otherwise, work locally.
- Delegate a code review to read-only independent subagent in order to reduce bias.
- Delegate a web research to read-only independent subagent in order to prevent context pollution.
- Give fresh-context subagents self-contained briefs with context, scope, constraints, applicable steps, completion checks, and expected output.
- Parallelize only independent subtasks. Give concurrent editors separate files or isolated changes. When access to a shared resource could conflict, schedule one operation at a time.
- Require completion status, results or changed files, verification evidence, and unresolved concerns. Blocked subagents must report missing information or resources and attempted work.

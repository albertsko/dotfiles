---
name: flow
description: Software engineering workflow.
disable-model-invocation: true
---

# Flow

For the coordinator only. A task is the main user request. A subtask is delegated work.

## Workflow

**Select host reference**

- Read [Claude Code](references/claude.md) for the current host. If unknown, stop and ask.
- Honor explicit model and effort choices. Available models and tool definitions override reference examples.

**Set up**

- Create one unique, descriptive `.scratch/{task-id}` dir per task. Reuse it across follow-up turns and all phases, including planning, implementation, verification, and review. Keep all task and subtask artifacts there. Exclude them from commits.
- When working cross repository, reuse the `{original-repo}/.scratch/{task-id}` dir.

**Delegate to subagent**

- Delegate work to subagent in order to avoid unnecessary context in the coordinator session.
- Parallelize subagents in order to save engineering time.
- Parallelize only independent subtasks. Give concurrent editors separate files or isolated changes. When access to a shared resource could conflict, schedule one operation at a time.
- When running subtasks in parallel, instead of working on a task while subtasks are working, wait for the all subtasks to be finished.
- Delegate a review to read-only independent subagents for two axis: unbiased review, correctnes review.

## PRD.md

Provide Product Requirement Document in the `.scratch/{task-id}` dir when user asked for it explicitly. Otherwise skip.

- Include stable contracts that stakeholders need to operate, integrate, validate, or approve.
- Exclude source paths, classes, functions, helper algorithms, and source code.
- Permit examples when a contract needs an exact shape.

**Problem Statement**

- Describe the user's problem from the user's perspective.

**Solution**

- Describe the solution from the user's perspective.

**User Stories**

- Provide a numbered list.
- Use the format: "As a [role], I want [capability], so that [benefit]."

**Acceptance Criteria**

- Define observable pass conditions for major workflows.
- Instead of repeating user stories, group criterias by workflow.

**Implementation Decisions**

- Record stable contracts, structures, schemas, interfaces, defaults, constraints, and state transitions.
- Keep repository layout and source code out of the document.

**Out of Scope**

- Describe excluded product behavior and delivery work.

**Assumptions and Open Questions**

- Give each active assumption a confidence level.
- Remove resolved questions. Move accepted answers into the relevant section.

**Further Notes**

- Record supporting context and important consequences.
- Keep requirements, open questions, and contracts in their named sections.

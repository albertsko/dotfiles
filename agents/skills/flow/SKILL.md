---
name: flow
description: Adaptive software engineering workflow.
disable-model-invocation: true
---

# Flow

- This skill is for the coordinator session only.
- Scale the process to uncertainty, dependencies, and the consequences of mistakes.
- A **task** is the main user request, owned by the coordinating agent.
- A **subtask** is part of the task delegated to a subagent.

## Select Host Reference

Use the current agent host:

- In Codex, read [codex.md](references/codex.md).
- In Claude Code, read [claude.md](references/claude.md).
- If the host is unknown, stop and ask.

Model and effort settings:

- Honor explicit model and effort choices. Tool definitions and available model lists take precedence over reference examples.
- Apply recommendations through controls exposed by the active session. If those controls are unavailable, retain the current settings.
- Correct missing context before increasing model capability or effort.
- Report a mismatch only when it materially affects the task.

## Set Up

- Start in a Git repository. If outside a repository, stop and ask for next steps.
- When notes or plans are needed, create a unique `.scratch/{task-id}` directory with a descriptive task ID. Keep task and subtask notes and plans there for the full task, and keep scratch artifacts out of commits.
- For long tasks, maintain durable notes of decisions, completed steps with evidence, blockers, and the next action. Before resuming after an interruption or handoff, reconcile the notes with repository state to avoid repeating completed work.

## Delegate

Apply these rules throughout the task:

- Delegate when worth the coordination cost, including when local work is highly likely to unnecessarily clutter the session context. Otherwise, work in the current session.
- Start subagents with fresh context. Give each a focused, self-contained brief covering relevant context, scope, constraints, applicable workflow steps, completion checks, and expected output.
- Own delegation and reviewer assignment. State in each subtask brief that further delegation requires your explicit assignment.
- Run subagents in parallel only when their subtasks have no sequential dependencies.
- Give concurrent editors exclusive ownership of files, or isolate their changes.
- Serialize conflicting access to shared resources.
- Require subagents to report subtask completion status, results or changed files, verification evidence, and unresolved concerns. Require blocked subagents to report what is missing and what was tried.
- Check the combined result after integrating delegated changes.

## Workflow

Follow this workflow for the task.

### 1. Inspect

- Read the relevant code, instructions, and evidence.
- Establish the requested outcome, constraints, and observable completion checks.
- Before editing, inspect existing workspace changes and run relevant baseline checks. Record preexisting failures and preserve unrelated changes.
- When the scope changes, state the new deliverable and carry forward accepted constraints.
- Ask for missing information when it changes the result. Continue independent work while waiting.

### 2. Plan

- Proceed directly on clear, bounded work within existing authorization.
- For consequential alternatives, compare tradeoffs and state the chosen approach and assumptions.
- For dependent work, identify prerequisites and sequence steps with observable completion checks. Before executing a multi-step plan, verify requirement coverage and agreement on shared interfaces and constraints.
- Ask before proceeding when an unresolved decision requires user input or the next action exceeds existing authorization.

### 3. Execute

- Work in sequential increments. Check each meaningful behavior change before building on it, with checks proportional to the change.
- Establish that new or changed tests detect the missing or incorrect behavior. For behavior fixes, add a repeatable regression check that fails without the fix and passes with it. Report when adding or demonstrating this check is impractical.

## 4. Resolve

- In case of failure, investigate the root cause before corrective edits: reproduce the problem, gather evidence, and test one hypothesis at a time. Before retrying a failed approach, change the hypothesis, evidence, or method.
- After repeated failures without progress, reassess the design and assumptions. Seek a fresh review or narrow the scope of the next repair attempt.
- Revisit the plan when new evidence invalidates it.

### 5. Review

- Check the actual changes against the requested behavior and likely failure modes.
- Use independent review when complexity or consequences justify delegation. Otherwise, review in the current session.
- Verify findings before applying them, then recheck affected behavior.
- Resolve each material finding by fixing it or recording why it is rejected or deferred.
- Do not build dependent work on an unresolved correctness issue.

### 6. Deliver

- Run checks appropriate to the final state.
- Match completion claims to observed results, including failed or skipped checks.
- Deliver the requested result, remaining findings, and any remaining work.

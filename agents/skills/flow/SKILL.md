---
name: flow
description: Adaptive software engineering workflow.
disable-model-invocation: true
---

# Flow

Scale the process to uncertainty, dependencies, and the consequences of mistakes.

## Select Host Reference

Use the current agent host:

- In Codex, read [codex.md](references/codex.md).
- In Claude Code, read [claude.md](references/claude.md).
- If the host is unknown, stop and ask.

Model and effort settings:

- Honor explicit model and effort choices. Tool definitions and available model lists take precedence over reference examples.
- Apply recommendations through controls exposed by the active session. If those controls are unavailable, retain the current settings.
- Report a mismatch only when it materially affects the task.

## Set Up

- Start in a Git repository. If outside a repository, stop and ask for next steps.
- Create a unique `.scratch/{task-id}` directory with a three-word task ID, such as `create-skill-flow`. The `.scratch/` directory is globally ignored.
- Keep task notes and plans in this directory. Reuse it across entire work of the same task.

## Delegate

Apply these rules throughout the task:

- Delegate when worth the coordination cost. Otherwise, work in the current session.
- Give each subagent a focused, self-contained brief with the relevant context, scope, constraints, completion checks, and expected output. Use fresh context for independent reviewers.
- The coordinating agent owns delegation and reviewer assignment. Subagents delegate further only when explicitly assigned that responsibility.
- Run subagents in parallel only when their tasks have no sequential dependencies.
- Give concurrent editors exclusive ownership of files, or isolate their changes.
- Serialize conflicting access to shared resources.
- Require subagents to report completion status, results or changed files, verification evidence, and unresolved concerns. When blocked, report what is missing and what was tried.
- Check the combined result after integrating delegated changes.

## Task Workflow

### 1. Inspect

- Read the relevant code, instructions, and evidence.
- Establish the requested outcome, constraints, and observable completion checks.
- Before editing, inspect existing workspace changes and run relevant baseline checks. Record preexisting failures and preserve unrelated changes.
- When the scope changes, state the new deliverable and carry forward accepted constraints.
- Ask for missing information when it changes the result. Continue independent work while waiting.

### 2. Plan

- Proceed directly on clear, bounded work within existing authorization.
- For consequential alternatives, compare tradeoffs and state the chosen approach and assumptions.
- For dependent work, identify prerequisites and sequence the work into steps with observable completion checks.
- Ask before proceeding when an unresolved decision requires user input or the next action exceeds existing authorization.

**For long tasks:**

- Keep durable notes of decisions, completed steps with evidence, blockers, and the next action.
- Update the notes as work progresses.
- Before resuming after an interruption or handoff, read the notes and reconcile them with the repository state to avoid repeating completed work.

### 3. Execute

- Work in sequential increments. Check each meaningful behavior change before building on it, with checks proportional to the change.
- For new or changed tests, establish that they detect the missing or incorrect behavior.
- For behavior fixes, add a repeatable regression check when practical. Verify that it fails without the fix and passes with the fix. Report when this is not practical.

### 4. Resolve

- In case of failure, investigate the root cause before corrective edits. Reproduce the problem, gather evidence, and test one hypothesis at a time.
- Correct missing context before increasing model capability or effort.
- When an approach fails, change the hypothesis, evidence, or method before retrying.
- Revisit the plan when new evidence invalidates it.

### 5. Review

- Check the actual changes against the requested behavior and likely failure modes.
- Use independent review when complexity or consequences justify delegation. Otherwise, review in the current session.
- Verify findings before applying them, then recheck affected behavior.
- Resolve each material finding by fixing it or recording why it is rejected or deferred.
- Do not build dependent work on an unresolved correctness issue.
- Report remaining findings.

### 6. Deliver

- Run checks appropriate to the final state.
- Match completion claims to observed results, including failed or skipped checks.
- Deliver the requested result and identify any remaining work.

---
name: flow
description: Adaptive software engineering workflow.
disable-model-invocation: true
---

# Flow

For the coordinator only. A task is the main user request. A subtask is delegated work. Scale the process to uncertainty, dependencies, and consequences.

**Select Host Reference**

Read [Codex](references/codex.md) or [Claude Code](references/claude.md) for the current host. If unknown, stop and ask.

- Honor explicit model and effort choices. Available models and tool definitions override reference examples.
- Use exposed controls to apply recommendations. Otherwise, retain current settings.
- Correct missing context before increasing capability or effort. Report setting mismatches only when material.

**Set Up**

- Work in a Git repository. Otherwise, stop and ask for next steps.
- When notes or plans are needed, keep all task and subtask artifacts in a unique, descriptive `.scratch/{task-id}` directory throughout the task. Exclude them from commits.
- For long tasks, record decisions, completed steps with evidence, blockers, and the next action. After interruption or handoff, reconcile notes with repository state before resuming.

**Delegate**

- Delegate when benefits outweigh coordination cost, including avoiding likely unnecessary context clutter. Otherwise, work locally.
- Give fresh-context subagents self-contained briefs with context, scope, constraints, applicable steps, completion checks, and expected output.
- Own delegation and reviewer assignment. Each brief must require your explicit assignment for further delegation.
- Parallelize only independent subtasks. Give concurrent editors exclusive file ownership or isolated changes. Serialize conflicting shared-resource access.
- Require completion status, results or changed files, verification evidence, and unresolved concerns. Blocked agents must report missing information or resources and attempted work.
- Verify the combined result after integration.

## 1. Inspect

- Read relevant code, instructions, and evidence. Define the outcome, constraints, and observable completion checks.
- Before editing, inspect workspace changes and run relevant baseline checks. Record existing failures and preserve unrelated changes.
- When scope changes, state the new deliverable and retain accepted constraints.
- Ask for missing information that changes the result. Continue independent work while waiting.

## 2. Plan

- Proceed directly on clear, bounded, authorized work.
- Compare consequential alternatives. State the chosen approach and assumptions.
- Sequence dependent work with prerequisites and observable completion checks. Before executing a multi-step plan, verify requirement coverage and agreement on shared interfaces and constraints.
- Ask when a decision needs user input or an action exceeds existing authorization.

## 3. Execute

- Work in sequential increments. Check meaningful behavior changes proportionally before building on them.
- Establish that new or changed tests detect missing or incorrect behavior. For fixes, add a repeatable regression check that fails without the fix and passes with it. Report when adding or demonstrating it is impractical.

## 4. Resolve

- Before corrective edits, reproduce failures, gather evidence, and test one root-cause hypothesis at a time. Change the hypothesis, evidence, or method before retrying a failed approach.
- After repeated failures without progress, reassess design and assumptions. Seek fresh review or narrow the next repair attempt.
- Revise plans invalidated by new evidence.

## 5. Review

- Review actual changes against requested behavior and likely failure modes. Use independent review when complexity or consequences justify delegation. Otherwise, review locally.
- Verify findings before applying them, then recheck affected behavior.
- Fix each material finding or record why it is rejected or deferred. Resolve correctness issues before building dependent work.

## 6. Deliver

- Run checks appropriate to the final state. Match completion claims to observed results, including failed or skipped checks.
- Deliver the requested result, remaining findings, and remaining work.

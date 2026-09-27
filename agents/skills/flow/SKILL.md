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
- Gather missing context before choosing a more capable model or increasing effort. Report setting mismatches only when they affect the work.

**Set Up**

- Work in a Git repository. Otherwise, stop and ask for next steps.
- When notes or plans are needed, create a unique, descriptive `.scratch/{task-id}` directory. Keep all task and subtask artifacts there throughout the task. Exclude them from commits.
- For long tasks, record decisions, completed steps with evidence, blockers, and the next action. After interruption or handoff, reconcile notes with repository state before resuming.

**Delegate**

- Delegate when the benefits outweigh the cost of coordination. Count avoiding unnecessary context as a benefit. Otherwise, work locally.
- Give fresh-context subagents self-contained briefs with context, scope, constraints, applicable steps, completion checks, and expected output.
- Assign subtasks and reviewers yourself. Each brief must require subagents to get your explicit assignment before delegating further.
- Parallelize only independent subtasks. Give concurrent editors separate files or isolated changes. When access to a shared resource could conflict, schedule one operation at a time.
- Require completion status, results or changed files, verification evidence, and unresolved concerns. Blocked agents must report missing information or resources and attempted work.
- Verify the combined result after integration.

## 1. Inspect

- Read relevant code, instructions, and evidence. Define the outcome, constraints, and observable completion checks.
- Before editing, inspect workspace changes and run relevant baseline checks. Record existing failures and preserve unrelated changes.
- When scope changes, state the new deliverable and keep the agreed constraints.
- Ask for missing information that changes the result. Continue independent work while waiting.

## 2. Plan

- When the work is clear, bounded, and authorized, proceed directly.
- Compare consequential alternatives. State the chosen approach and assumptions.
- Put dependent work in order. Define what each step needs before it can start and how to check completion. Before executing a multi-step plan, check that the plan covers all requirements. Confirm agreement on shared interfaces and constraints.
- Ask when a decision needs user input or an action exceeds existing authorization.

## 3. Execute

- Work in small, sequential steps. Before building on a meaningful behavior change, check the change in proportion to its scope and risk.
- Verify that new or changed tests detect missing or incorrect behavior. For fixes, add a repeatable regression check that fails without the fix and passes with it. Report when adding or demonstrating the check is impractical.

## 4. Resolve

- Reproduce failures and gather evidence. Before corrective edits, test one root-cause hypothesis at a time. Change the hypothesis, evidence, or method before retrying a failed approach.
- After repeated failures without progress, reassess design and assumptions. Seek fresh review or narrow the next repair attempt.
- Revise plans invalidated by new evidence.

## 5. Review

- Review actual changes against requested behavior and likely failure modes. Use independent review when complexity or consequences justify delegation. Otherwise, review locally.
- Verify findings before applying them. Then recheck affected behavior.
- Fix each material finding or record why it is rejected or deferred. Resolve correctness issues before building dependent work.

## 6. Deliver

- Run checks appropriate to the final state. Match completion claims to observed results. Report failed or skipped checks.
- Lead with the requested result. Then report remaining findings and work.

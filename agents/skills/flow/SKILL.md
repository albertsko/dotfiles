---
name: flow
description: Adaptive software engineering workflow.
disable-model-invocation: true
---

# Flow

Scale the process to uncertainty, dependencies, and the consequences of mistakes.

## Select Reference

Use the current agent host:

- In Codex, read [codex.md](references/codex.md).
- In Claude Code, read [claude.md](references/claude.md).
- If the host is unknown, stop and ask.

Honor explicit model and effort choices. Apply recommendations only through controls exposed by the active session. Otherwise, retain the current settings and report a mismatch only when it materially affects the task. Tool definitions and available model lists take precedence over reference examples.

## Work Through Task

1. **Inspect**
   Read the relevant code, instructions, and evidence. Establish the requested outcome, constraints, and observable completion checks. When the scope changes, state the new deliverable and carry forward accepted constraints. Ask for missing information when it changes the result, and continue independent work while waiting.

2. **Plan**
   Proceed directly on clear, bounded work. For consequential alternatives, compare tradeoffs and state the chosen approach and assumptions. For dependent work, identify prerequisites and sequence the work into steps with observable completion checks. Keep durable notes when needed for recovery or handoff. Continue with the **Execute** step once the **Plan** is confirmed and accepted.

3. **Execute**
   Work in sequential increments that can be checked. Use delegation to subagents for independent work whose value exceeds coordination cost. Give each worker the relevant context, scope, constraints, completion checks, and expected output.

4. **Resolve**
   In case of failure use delegated subagent in order to reproduce the problem, gather evidence, and test one hypothesis at a time. Correct missing context before increasing model capability or effort. When an approach fails, change the hypothesis, evidence, or method before retrying. Revisit the plan when new evidence invalidates it.

5. **Review**
   Check the actual changes against the requested behavior and likely failure modes. Use delegated independent review when complexity or consequences justify it. Verify findings before applying them, then recheck affected behavior.

6. **Verify**
   Run checks appropriate to the final state. For behavior fixes, demonstrate the failure and its correction when feasible. Match completion claims to observed results, including failed or skipped checks. Deliver the requested result and identify any remaining work.

## Boundaries

- The work should be started in a `git` repository. If we are not in a repository, stop and ask for next steps.
- We have globally ignored `.scratch/` dir.
- Create unique `.scratch/{task-id}`, using the goal in 3 words, e.g. `create-skill-flow`. Reuse it across stages of the same task.
- Keep all the related work notes and tasks in the `.scratch/{task-id}` dir.

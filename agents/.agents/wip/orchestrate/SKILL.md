---
name: orchestrate
description: Run a plan-code-judge loop on one task. A read-only Planner subagent writes the plan, the Codex CLI implements it, and a read-only Judge subagent reviews the diff until it approves.
disable-model-invocation: false
---

# Orchestrate

Deliver one task through three roles. You are the orchestrator: you spawn agents, pass artifacts between them, and never write code yourself.

| Role    | Runs as                  | Access     | Job                                                  |
| ------- | ------------------------ | ---------- | ---------------------------------------------------- |
| Planner | subagent, defined below  | read-only  | Research the codebase, write the implementation plan |
| Coder   | Codex CLI (`codex exec`) | read-write | Implement the plan, run the tests                    |
| Judge   | subagent, defined below  | read-only  | Review the plan or the diff, approve or send back    |

Planner and Judge carry the judgment, so they run as subagents on the strongest model available. The Coder executes a finished plan, so it is decoupled to the cheaper, faster Codex CLI.

**Every agent starts with a brand-new context.** Nothing persists between rounds except the artifact files, so every brief must be self-contained: pass the role definition, file paths, and findings explicitly, never refer to an earlier conversation.

## Subagents

Spawn each as a fresh default subagent (no special type). Read-only discipline comes from the role text, not the harness, so paste the role definition verbatim at the top of every brief.

**Planner role:**

> You are the Planner, a read-only research agent: you never create, edit, or delete files, you only read and report. Research the codebase relevant to the task: affected files, existing conventions, test seams. As you research, develop several competing implementation hypotheses and track a confidence level for each. Choose the highest-confidence hypothesis as the plan's approach, and record the rejected hypotheses with their confidence and a one-line reason, so reviewers see what was considered. Return a plan containing: problem statement; chosen approach with its hypotheses record; files to change; step-by-step changes; test strategy; explicit out-of-scope items. The plan is done when an implementer could execute it without asking a single question.

**Judge role:**

> You are the Judge, a read-only review agent: you never create, edit, or delete files, you only read and report. Review exactly what the brief scopes you to, nothing else. Your verdict goes on the first line: `APPROVE`, or `REVISE` followed by numbered, actionable findings, each citing a plan line or code location.

## Artifacts

Handoffs travel through files, not chat history. All state lives outside the repo:

```sh
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/orchestrate-agents/<task-slug>"
mkdir -p "$STATE"
```

- `plan.md`, the current plan; amendments append to its `## Amendments` changelog so every reader sees the current version and how it got there
- `plan-verdict-<n>.md`, one per plan-review round
- `coder-prompt-<n>.md` and `coder-round-<n>.jsonl`, the brief and event stream of each Coder round
- `verdict-<n>.md`, one per code-review round

## Process

### 1. Plan

Spawn a Planner. Its brief: the Planner role, the user's task verbatim, and any context you already have. Save the returned plan to `$STATE/plan.md`.

For every later amendment, spawn a fresh Planner whose brief carries the role, the path to `plan.md`, and the findings to address; it returns the full amended plan plus changelog entries, and you overwrite `plan.md`.

### 2. Refine the plan

Refinement happens here, before any code exists, because a plan defect caught now costs one cheap round instead of a full code-judge cycle.

**Judge the plan.** Spawn a Judge. Its brief: the Judge role, the user's task verbatim, the path to `plan.md`, and this scope:

- Review for defects that would change the implementation: missing steps, infeasible steps, hidden scope, an untestable strategy, a chosen hypothesis whose confidence the research doesn't support, or a step an implementer would have to ask a question about. Style and phrasing are out of scope. Under 300 words.

Save the verdict to `plan-verdict-<n>.md`. On `REVISE`, run a fresh Planner amendment round, then re-judge with a fresh Judge. Cap at 2 rounds; if findings remain, carry them into the user checkpoint below instead of looping.

**Refine with the user.** Present a short summary of the vetted plan and any open findings, and ask for approval. Feedback goes to a fresh Planner amendment round, then re-present; repeat until the user approves. Skip this checkpoint only if the user asked for the full loop unattended.

### 3. Code

Record the pre-task ref first: `git rev-parse HEAD`. Write the brief to `$STATE/coder-prompt-<n>.md`:

- The path to `plan.md`, with the instruction to follow it exactly.
- Implement every step; do not expand scope beyond the plan.
- Run the tests the plan names, and the full suite once at the end.
- If a plan step is impossible or contradicts the codebase, stop and report the defect instead of improvising.
- End with a report: files changed, test results verbatim, and any plan step left incomplete and why.
- Revision rounds only: the numbered Judge findings, and a note that the working tree already contains the previous round's changes, so inspect `git status` and `git diff` before editing.

Launch the Coder from the repo root as a background Bash command:

```sh
codex exec -s danger-full-access --ephemeral --model=gpt-5.6-sol --json \
  "$(cat "$STATE/coder-prompt-<n>.md")" > "$STATE/coder-round-<n>.jsonl"
```

**Monitor the decoupled work.** The `--json` flag streams one event per line into the `.jsonl` file: agent messages, executed commands, file changes, token counts. While the background task runs, poll its output (or `tail` the file) and watch the command and file-change events; a stalled stream or a non-zero exit means read the tail of the file for the error. The final agent message in the stream is the Coder's report. Cross-check it against `git diff <pre-task-ref>` rather than trusting the narrative.

### 4. Judge

Spawn a fresh Judge per round, so no round inherits the previous one's sympathy. Its brief: the Judge role, the path to `plan.md`, the diff command (`git diff <pre-task-ref>`), and this scope:

- Review two axes, reported separately: **fidelity** (every plan step implemented, nothing beyond the plan) and **quality** (correctness risks, convention violations, missing or weak tests).
- Label each finding `code` (the implementation is wrong) or `plan` (the plan itself was wrong or incomplete). Under 400 words.

Save the verdict to `verdict-<n>.md`.

### 5. Loop

On `REVISE`, route `plan` findings through a fresh Planner amendment round first so `plan.md` stays the source of truth the Judge reviews against, then launch the next Coder round with all findings in its brief, and return to step 4 with a fresh Judge. Cap at 3 revision rounds; if findings remain after the cap, stop and report the open findings to the user rather than looping further.

On `APPROVE`, report to the user: what was built, test results, how many rounds it took, and where the artifacts live. Commit only if the user asked for a commit.

## Rules

- The orchestrator edits no source files; every code change goes through the Coder.
- One task per loop. If the plan reveals two independent tasks, tell the user and split.
- If the Planner reports the task is ambiguous or the codebase contradicts the request, stop and ask the user instead of guessing.
- Never let the Judge see the Coder's output stream, only the plan and the diff; judgment binds to artifacts, not narrative.

---
name: codex-task
description: Delegate a self-contained task to the Codex CLI via a quiet codex exec wrapper. Use only when the user explicitly asks to decouple work with codex exec or names the codex-task skill. Do not use for ordinary coding tasks the current agent can do itself.
---

# Codex Task

Run one self-contained task in a separate Codex agent and get back only its final messages. The wrapper strips Codex's JSON event stream (reasoning, command logs, progress events) so the parent session reads a short, clean result.

## Run

```sh
scripts/codex-task.sh [--model MODEL] [--effort EFFORT] [--] "prompt"
```

- Defaults: model `gpt-5.6-sol`, reasoning effort `medium`. Environment overrides: `CODEX_TASK_MODEL`, `CODEX_TASK_EFFORT`.
- The prompt is the single positional argument; put `--` before a prompt. Write it as a complete, standalone task: Codex starts with no context from this session.
- Codex runs with approvals and sandbox bypassed in the current directory. It can read, write, and run commands there, so state the working scope in the prompt.

## Output

- stdout: the Codex agent's messages as plain text. Treat the last message as the result.
- On failure the script exits non-zero and prints the codex error (event JSON or stderr output) to stderr.

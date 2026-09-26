# Codex model selection

| Action                                                        | Model         | Effort                         |
| ------------------------------------------------------------- | ------------- | ------------------------------ |
| Focused extraction, summaries, mechanical edits               | `gpt-6-luna`  | `high`                         |
| Ordinary implementation, tests, bounded debugging and review  | `gpt-6-sol`   | `medium`                       |
| Ambiguous investigation, architecture, broad integration      | `gpt-6-astra` | `low`, then increase if needed |
| Difficult correctness review or unresolved reasoning problems | `gpt-6-astra` | `high`                         |

- For a bounded task or subtask that exceeds Luna's capability, move to Sol.
- For broader reasoning that exceeds Sol's capability, move to Astra.
- Increase effort when adequate evidence still requires deeper analysis.
- Reserve `xhigh` and `max` for problems that justify additional time and usage.
- `ultra` adds automatic delegation, so use it only when useful for separable work. Luna does not support `ultra`.

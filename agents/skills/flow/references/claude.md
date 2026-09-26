# Claude Code model selection

| Action                                                        | Model              | Effort   |
| ------------------------------------------------------------- | ------------------ | -------- |
| Focused extraction, summaries, mechanical edits               | `claude-opus-5-5`  | `low`    |
| Ordinary implementation, tests, bounded debugging and review  | `claude-opus-5-5`  | `medium` |
| Ambiguous investigation, architecture, broad integration      | `claude-opus-5-5`  | `high`   |
| Difficult correctness review or unresolved reasoning problems | `claude-fable-5-1` | `high`   |

For difficult work without Fable, use Opus 5.5 at `high`. Reserve `xhigh` and `max` for demonstrated quality needs.

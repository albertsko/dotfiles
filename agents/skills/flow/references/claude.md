# Claude Code model selection

| Action                                                        | Model               | Effort   |
| ------------------------------------------------------------- | ------------------- | -------- |
| Focused extraction, summaries, mechanical edits               | `claude-sonnet-5-5` | `medium` |
| Ordinary implementation, tests, bounded debugging and review  | `claude-opus-5-5`   | `medium` |
| Ambiguous investigation, architecture, broad integration      | `claude-opus-5-5`   | `high`   |
| Difficult correctness review or unresolved reasoning problems | `claude-opus-5-5`   | `high`   |

Reserve `xhigh` and `max` for demonstrated quality needs.

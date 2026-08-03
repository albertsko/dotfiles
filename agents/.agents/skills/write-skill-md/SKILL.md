---
name: write-skill-md
description: Guide for authoring AI agent skills in the open SKILL.md format. Use when creating a new skill, reviewing or improving an existing SKILL.md, or deciding whether repeated instructions should become a skill.
disable-model-invocation: true
---

# Write SKILL.md

A skill is a folder with a required `SKILL.md` and optional supporting files. The format is an open standard adopted across AI agents, so one well-written skill is portable between them.

```
skill-name/
├── SKILL.md      # required: YAML frontmatter + instructions
├── scripts/      # optional: executable code for deterministic, repeated work
├── references/   # optional: detailed docs, loaded only when needed
└── assets/       # optional: templates and files copied into output, never loaded
```

## When To Write A Skill

- Write a skill when you keep reusing the same prompt or correcting the same workflow.
- One skill, one job. Split a skill that covers two workflows.
- Always-on behavior (style, conventions) belongs in the agent's context file (e.g. AGENTS.md); a skill is for on-demand, task-specific procedure.

## Frontmatter

Two required fields:

- `name`: lowercase letters, digits, hyphens; 1 to 64 chars; must match the folder name.
- `description`: what the skill does and when to use it, up to 1024 chars.

The description is the router. The agent sees only name and description at startup, and picks the skill by description alone, so:

- Write it in third person: "Extracts text from PDF files", not "I can help you...".
- State the trigger conditions: "Use when the user mentions PDFs, forms, or document extraction."
- Include the concrete words users actually say, and front-load the key use case, long descriptions get truncated.
- Agents undertrigger, so be a little pushy: "Use whenever the user mentions dashboards or metrics, even if they don't say 'dashboard'."

## Progressive Disclosure

Match content to its loading tier, the context window is a public good:

1. Frontmatter loads always (~100 tokens). Carries discovery only.
2. SKILL.md body loads on trigger. Keep it under 500 lines; only the procedure.
3. `references/` and `scripts/` load or run only when needed. No size limit.

Move detail out of the body: schemas, API docs, and long examples go in `references/`, linked from SKILL.md with a note on when to read each ("For tracked changes, read REFERENCE.md"). Keep references one level deep. Never duplicate content between body and references.

## Writing The Body

- Assume the agent is already smart. Cut any explanation it doesn't need; ask of every paragraph whether it justifies its token cost.
- Use imperative, verb-first steps with explicit inputs, outputs, and done criteria.
- Give one default approach plus an escape hatch, not a menu of options.
- Pick one term per concept and keep it.
- Explain why a rule matters instead of shouting ALL-CAPS MUSTs; a reasoned rule generalizes, a shouted one gets pattern-matched.
- Quantify constraints: "at most 5 bullets" beats "be concise".
- Resolve contradictions with explicit conditions: "simple queries: 3 to 6 sentences; multi-step tasks: a structured plan". Contradictory instructions are the most damaging defect.
- Match specificity to fragility: fragile or high-stakes sequences get exact commands ("Run exactly `python scripts/migrate.py --verify`"); open-ended judgment gets heuristics and trust.
- Show 2 to 3 before/after or input/output examples; examples convey style better than descriptions.

## Scripts

- Bundle a script when the agent would otherwise rewrite the same code every run, or when the step must be deterministic.
- Make intent explicit: "Run `analyze.py` to extract fields" (execute) vs "See `analyze.py` for the algorithm" (read).
- Scripts handle their own errors and justify every constant in a comment; list dependencies and how to install them.

## Test And Iterate

- Test in a fresh session; authoring context masks gaps in the written instructions.
- Measure two things separately: does it trigger on the right prompts, and is the output right when it does.
- Write should-trigger prompts and near-miss should-NOT-trigger prompts (same keywords, different need) before polishing the docs.
- Watch how the agent navigates: a never-read reference gets deleted or signposted better, an always-read one gets inlined.
- Generalize from failures instead of patching each one with a narrow rule, and keep removing lines that aren't pulling their weight.

## Checklist

1. Does the description say what and when, in third person, with trigger keywords up front?
2. Does the folder name match `name`?
3. Is the body under 500 lines, with detail pushed to references one level deep?
4. Is every step imperative, with one default approach and quantified constraints?
5. No contradictions, no unexplained MUSTs, no duplicated content?
6. Tested in a fresh session, both triggering and output?

## Sources

- [Anthropic: skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [Agent Skills specification](https://agentskills.io/specification)
- [OpenAI: build skills for Codex](https://developers.openai.com/codex/skills)
- [Gemini CLI: creating skills](https://geminicli.com/docs/cli/creating-skills/)

---
name: write-agents-md-reference-doc
description: Guide for writing reference documents linked from AGENTS.md or CLAUDE.md. Use when extracting an oversized AGENTS.md section into its own file, creating or reviewing a doc that agents load on demand (rule inventories, decision tables, subsystem specs, debugging notes), or deciding whether content belongs in AGENTS.md, a reference doc, or a skill.
disable-model-invocation: true
---

# Write AGENTS.md Reference Doc

A reference doc holds detail that AGENTS.md is too small for. AGENTS.md loads every session; a reference doc loads only when the agent has a reason to read it. Linked references get read in over 90% of relevant sessions; docs not linked from AGENTS.md get found in under 10% — a reference doc without a link line is dead weight.

For the AGENTS.md side (what stays in the main file, the 10–15 reference cap), follow `write-agents-md`.

## When To Create One

- An AGENTS.md section grows past ~20 lines.
- Rule inventories: 15+ warnings or lint-style rules stacked in the main file make agents verify every solution against every rule.
- Decision tables or branching cases too long for one line.
- Subsystem specs, failure modes, and debugging knowledge that recur but only matter for some tasks.

Not a reference doc: task procedures with steps and done-criteria — those are skills. A reference doc is read; a skill is followed.

## Writing The Doc

- One topic per doc, scoped by subsystem or concern; name the file after the topic (`docs/agents/db-migrations.md`, not `docs/misc.md`).
- State the scope in the first line so an agent can bail early: "Rules for writing and reviewing Drizzle migrations."
- Keep it 100–150 lines. If it outgrows that, split by concern — never chain doc → doc; keep references one level deep from AGENTS.md.
- Same writing rules as AGENTS.md: imperative, testable, exact commands, don't/do pairs, removal test on every line.

## Where To Put It

No tool defines a standard reference-doc directory, so pick one tool-agnostic location per repo and keep every doc there. Default to `.agents/references/` next to AGENTS.md; `docs/agents/` works too.

Avoid tool-specific homes, they break the doc for every other agent and often load eagerly, defeating the on-demand purpose:

- `.claude/rules/` (Claude Code) loads at launch, or on path-match with `paths` frontmatter — that is for always-on rules, not references.
- `instructions` entries in `opencode.json` (opencode) also load every session.

When a tool does require its own path (e.g. `.claude/skills`), symlink the whole directory to the `.agents/` source (`ln -s ../.agents/skills .claude/skills`) instead of duplicating files — one source of truth, nothing to keep in sync.

## Linking From AGENTS.md

One line per doc, stating the trigger condition, not just the topic:

Before: `See docs/agents/db-migrations.md.`

After: `Before creating or editing any file in drizzle/migrations/, read .agents/references/db-migrations.md.`

Write the path in backticks or a plain markdown link, never as a bare `@path`: Claude Code expands a bare `@path` in CLAUDE.md as an import at session start, which loads the doc every session and defeats on-demand loading.

## Maintenance

- Update the doc in the same PR that changes what it describes.
- A doc the agent never reads is either mislinked (fix the trigger line) or unneeded (delete it, orphaned docs still rot in grep results).

## Checklist

1. Is the doc linked from AGENTS.md with a trigger condition, as a backticked path, not `@path`?
2. In the repo's one reference directory (default `.agents/references/`), not a tool-specific dir?
3. One topic, scope stated in the first line, under 150 lines?
4. One level deep — no doc-to-doc chains?
5. Would this content be better as a skill (procedure) or inline in AGENTS.md (always-on fact)?

## Sources

- [Augment Code: how to write good AGENTS.md files](https://www.augmentcode.com/blog/how-to-write-good-agents-dot-md-files)
- [Scaling your coding agent's context beyond a single AGENTS.md](https://ursula8sciform.substack.com/p/scaling-your-coding-agents-context)
- [Claude Code docs: Memory & CLAUDE.md](https://code.claude.com/docs/en/memory.md)
- [opencode docs: Rules](https://opencode.ai/docs/rules/)

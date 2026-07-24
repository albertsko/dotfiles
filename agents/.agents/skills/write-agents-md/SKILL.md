---
name: write-agents-md
description: Guide for writing AGENTS.md context files for AI coding agents. Use when creating, reviewing, or improving an AGENTS.md or CLAUDE.md, deciding what belongs in the context file versus a skill, or structuring context files in a monorepo.
---

# Write AGENTS.md

AGENTS.md is the open, cross-tool standard for agent context files: a "README for agents" read by Claude Code (via CLAUDE.md, see Interop), Codex, Cursor, Copilot, Gemini CLI, and others. Agents load the nearest AGENTS.md walking up the directory tree, so nested files scope instructions per package.

## The Core Principle

Every line is a tax on every future session. Research on real repositories ([arXiv:2602.11988](https://arxiv.org/abs/2602.11988)) found context files often add over 20% inference cost without improving task success, and LLM-generated files actively reduce it. The file earns its keep only with facts the agent cannot infer from the code.

Apply the removal test to every line: **would deleting this line cause a mistake?** If not, delete it.

## What Belongs

- Exact commands the agent would guess wrong: package manager, build, test (including single-file mode), lint, dev server.
- Rules that differ from language/framework defaults, one per recurring mistake.
- Boundaries in three tiers: always do / ask first / never do. Put the "never" rules at the top of the file; earlier lines carry more weight.
- Repository etiquette: branch naming, commit format, PR conventions.
- Environment quirks: required env vars, auto-reload behavior, non-obvious gotchas.
- Pointers to skills and reference docs, with when to read each, at most 10–15 references per file. To write a reference doc, follow `write-agents-md-reference-doc`.

## What Does Not

- Anything inferable from the code: standard conventions, file-by-file descriptions, API details.
- Copied README or style-guide content; different audience, different job.
- Vague aspirations ("write clean code"), they provide zero decision support and teach the agent to ignore the file.
- Long architecture essays: 10 lines of layout and connections at most; the agent reads actual files for specifics.
- Task-specific procedures, those are skills, loaded on demand. Always-on facts stay in AGENTS.md; if a section grows past ~20 lines, extract it into a skill or reference doc.

## Writing Rules

- Be imperative and exact: "Use pnpm, never npm" beats "we prefer pnpm". Paste the literal command, pin versions.
- Pair every "don't" with a "do": "Don't instantiate HTTP clients directly; use the shared `apiClient` from `lib/http`."
- Make rules testable: "2-space indent, never tabs", not "format properly".
- Prefer a 3–10 line snippet from real production code over prose descriptions of style.
- For ambiguous choices, use a short decision table ("state that survives navigation → Zustand; server cache → React Query").
- Keep it under 150 lines; treat 300 as a hard limit, adherence drops off beyond that.
- No conditional sprawl ("if TypeScript, do X") and no walls of warnings; move rule inventories to reference files.

## Monorepos

- Root AGENTS.md: package layout, shared conventions, package manager, commit format, thin.
- Per-package AGENTS.md: that package's stack, commands, and env vars. Nearest file wins; owners maintain their own.

## Claude Code Interop

Claude Code reads CLAUDE.md, not AGENTS.md. Keep the tool-agnostic files (`AGENTS.md`, `.agents/`) as the single source of truth and symlink the tool-specific paths to them — a symlink is a filesystem alias, so there is nothing to keep in sync, and whole directories alias in one line:

```sh
ln -s AGENTS.md CLAUDE.md
ln -s ../.agents/skills .claude/skills
```

Fall back to an `@AGENTS.md` import only when you need Claude-specific additions, or on Windows, where symlinks require admin rights or Developer Mode:

```markdown
@AGENTS.md

## Claude Code Specific

...
```

CLAUDE.md files concatenate down the hierarchy (user `~/.claude/CLAUDE.md` → project root → subdirectory). Commit AGENTS.md/CLAUDE.md to git; keep personal-only content in gitignored `CLAUDE.local.md`. Rules you want enforced at all costs belong in hooks, not the context file.

## Maintenance

- Add rules reactively: when the agent repeats a mistake, that is a gap in the file. Write the file by hand; don't generate it wholesale.
- Update the file in the same PR that changes a convention; review every 3–6 months and delete rules that stopped pulling their weight (newer models need fewer workarounds).
- Fix the documentation environment, not just the entry point: a focused 150-line AGENTS.md on top of hundreds of kilobytes of stale specs won't keep the agent out of the specs. Prune or quarantine surrounding docs too.

## Examples

**Vague → Testable**

Before: `Write tests for your changes.`

After: ``Run \`npm test -- src/foo.test.ts\` (single-file mode) while iterating; run the full \`npm test\` before committing.``

**Prose → Command**

Before: `We use pnpm as our package manager and prefer that dependencies are kept up to date.`

After: ``Install with \`pnpm install\`. Never use npm or yarn; the lockfile is pnpm-only.``

**Essay → Layout**

Before: 40 lines narrating the request lifecycle through every layer.

After:

```
apps/api    Fastify service; owns all DB access (Drizzle)
apps/web    Next.js 15, App Router; calls api via @repo/client
packages/*  shared types and config; no runtime deps on apps
```

## Checklist

1. Does every line pass the removal test?
2. Are the never-do rules at the top?
3. Are all commands literal and copy-pasteable, with versions pinned?
4. Is every "don't" paired with a "do", and every rule testable?
5. Under 150 lines, with procedures extracted to skills and detail to references?
6. Monorepo: thin root plus per-package files?

## Sources

- [agents.md, the open standard](https://agents.md/)
- [Claude Code docs: Memory & CLAUDE.md](https://code.claude.com/docs/en/memory.md)
- [Claude Code docs: Best practices](https://code.claude.com/docs/en/best-practices.md)
- [Claude Code docs: Large codebases](https://code.claude.com/docs/en/large-codebases.md)
- [Evaluating AGENTS.md (arXiv:2602.11988)](https://arxiv.org/abs/2602.11988)
- [Augment Code: how to write good AGENTS.md files](https://www.augmentcode.com/blog/how-to-write-good-agents-dot-md-files)

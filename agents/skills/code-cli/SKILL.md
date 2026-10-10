---
name: code-cli
description: Use when designing, building, extending, or reviewing a command-line tool (CLI) or its full-screen terminal UI (TUI), or making one usable by agents.
---

# Code CLI

## Purpose

Build predictable interfaces for the tool's actual users: people, scripts, agents, or a combination. Cite stable rule IDs, such as "CORE-8", in designs and findings. Separate shared contracts from product defaults and optional recipes.

## Scope and references

Before loading detailed rules, record the work and relevant capabilities:

- Consumers and output roles: structured results, native text/byte streams, generated artifacts, or an existing protocol.
- Interfaces and lifetime: one or several interfaces, shared in-process operations or independent peers, short-lived commands or persistent work.
- Interaction and trust: terminal interaction, noninteractive use, mutations, untrusted input, credentials, and external entrypoints.

This applicability record does not require every capability. Existing contracts and the requested scope constrain the design.

Before setting scope, scan the section headings and applicability conditions in [references/cli.md](references/cli.md) and [references/arch.md](references/arch.md). Load detailed rules for affected capabilities, including bounded behavioral changes:

| Affected capability | Architecture sections or rules to read |
|---|---|
| New design or structure change | "Choose a level", then sections for the selected capabilities |
| Mutation | "Mutation pipeline" |
| Background or parallel work | "Background work" |
| Transport or untrusted filesystem paths | "Transport and filesystem trust", with ARCH-49 applying wherever confinement is required |
| Authorization, restricted callers, or untrusted action inputs | ARCH-51 to ARCH-53 |
| External API | ARCH-61 |
| Verification, refactoring, or publication | Applicable rules in "Enforcement and testing" |

Read matching CLI sections for command behavior. A new design or full review covers every applicable section. L0 permits small functions, not mandatory package hierarchies. Capability pointers retain their conditions and do not require unused architecture levels.

For full-screen TUI work, read applicable sections of [references/tui.md](references/tui.md) and the rules named by their pointers. These pointers do not force unrelated levels. Read language guidance when the language/stack is known.

For a bounded change or review, the scope set contains core rules, affected sections, and their dependencies. Record exclusions. Use that same set for implementation, review, and completion. Consulting one reference does not add every rule in its file to scope.

## Terms

- **Agent**: an AI agent running the tool without a person at the keyboard.
- **Script**: a CI job or shell script running the tool.
- **TTY**: a terminal device on a stream or explicitly opened for interaction. It indicates capabilities, not human presence.
- **Machine output**: a documented programmatic format, including native formats and explicit modes such as `--json` or `--plain`.
- **Contract**: accepted input, output format and streams, exit behavior, and compatibility promises.
- **Mutation**: a command changing local or remote state.
- **Agent opt-in**: an explicit control for behavior that changes established interaction. It is not authentication or a requirement to hide generally useful automation features.

## Core rules

- **CORE-1** Choose defaults for intended consumers and preserve existing contracts. Prefer human-readable defaults for human-facing administrative commands. Keep machine-native defaults for filters, protocol endpoints, and automation tools whose purpose requires them. Share operations across consumers, with opt-ins where interaction or presentation differs. `[S1,S2,S3,S4]`
- **CORE-2** Send primary results to stdout and diagnostics to stderr. Follow an existing protocol's channel contract for a protocol endpoint. CLI `--json` uses the complete stderr contract in CLI-46, including unexpected failures. `[S1,S2]`
- **CORE-3** Exit with 0 on success and non-zero on failure, with distinct codes for important failure modes. Preserve established domain-specific exit semantics. CLI-49 gives a default map for new commands. `[S1,S2,S4]`
- **CORE-4** Provide `-h` and `--help` on commands and subcommands. Parse them with the normal grammar, respecting values and `--`: `--name -h` may supply a value, and `-- -h` supplies an operand. Parsed help bypasses domain validation, configuration, and execution. Malformed option syntax may still be a usage error; help needs no incompatible second parser. `[S1]`
- **CORE-5** Use standard flag names where they exist, and give each flag a full-length version. CLI-54 lists standard names. `[S1]`
- **CORE-6** Offer `--json` for structured results when callers need a machine interface and no suitable native contract exists. Keep the default chosen by CORE-1. Artifacts, generated shell code, native filters, streaming protocols, and terminal sessions retain their declared formats rather than arbitrary JSON wrappers. Define metadata and error channels separately. `[S1,S2,S4]`
- **CORE-7** Treat machine output as a contract from its first release: stable fields, types, framing, and streams. Human presentation may change. Tell callers which native or explicit machine mode is stable. `[S1,S2,S4]`
- **CORE-8** For line-based CLI operations and application actions selected for automation under TUI-2, provide a noninteractive path for every required input using args, flags, files, stdin, or credential channels as appropriate. TUI-2 owns TUI parity; a TUI-only action needs no new CLI path. Auto-prompt only with terminal input and a visible terminal prompt destination, never in finite JSON mode (CLI-46). An explicitly requested interactive mode may use a separate controlling terminal while data uses pipes. `--no-input` disables all interaction and rejects an interactive-only path. If a supported noninteractive operation lacks input, name its input path. `[S1,S2,S4]`
- **CORE-9** Match confirmation to risk (CLI-84). When required, ask for `y` or `yes` on a usable interaction terminal. With interaction off, require `-f, --force`; for a severe action using a typed resource name, require `--confirm="name"` instead. Confirmation does not bypass authorization or changed-target checks. `[S1,S2]`
- **CORE-10** Treat `--no-input` as nothing interactive: no prompts, pager, editor, or TUI. It never means yes. A required confirmation fails and names `--force` or `--confirm`. `[S1,S4]`
- **CORE-11** Render expected errors as short messages with a useful next step and stable machine error kinds where promised. Keep stack traces and internal details in explicitly requested, redacted debug output (CLI-47). `[S1,S3]`
- **CORE-12** Emit no styling in machine formats. For human output, `--no-color`, nonempty `NO_COLOR`, `TERM=dumb`, or `FORCE_COLOR=0` disable color. Otherwise a supported positive `FORCE_COLOR` setting may enable color off-TTY; without overrides, detect each stream separately. Color overrides do not enable animation or interaction. `[S1,S2,S4]`
- **CORE-13** Prefer secret references and protected channels: a file flag such as `--password-file`, stdin or a hidden terminal prompt, private IPC, or a secret manager. Keep secret values out of argv. Avoid secret env vars by default; document the exposure and redaction boundary when an existing integration requires them. Process inspection, inheritance, history, and logs have different risks by channel and platform. `[S1]`

## Rule statuses

Give each in-scope rule a status:

- `pass`: the design or observed behavior meets the applicable requirement.
- `fail`: evidence shows a violation, including missing required behavior.
- `open`: required design content or a decision is missing.
- `unverified`: behavior applies but evidence is unavailable or insufficient. Name the missing check and its consequence.
- `n/a`: a condition is false or an optional suggestion was not selected. Give a short reason, which may cover a section.
- `waived`: a requirement or default is intentionally overridden by the user or a documented constraint. Give the reason and resulting contract.

"Consider" marks a suggestion. Skipping it is `n/a`, not failure or a mandatory design essay. If selected, check the resulting behavior. "Prefer" and "default" mark defaults: an explicit compatible product choice can replace them, recorded as `waived` with the resulting contract. Other applicable rules are requirements, subject to documented exceptions.

An impossible design choice is `fail`, not `open`. Missing architecture decisions leave affected design rules `open`, not inapplicable. Pointers retain the target rule's applicability. Evidence gaps are neither waivers nor passes. Group consecutive rules with the same status and reason to keep checklists compact.

## Fix order

Prioritize security, data integrity, and wrong-target behavior, then contract failures and blocked normal use, then maintainability and presentation. Consider exposure and prerequisites. Use file/rule order only as a tie-breaker. Keep unverified high-risk behavior visible.

## Workflows

### Design a new CLI

1. Record scope, users, high-impact tasks, and compatibility constraints.
2. Choose architecture capabilities with ARCH-1 to ARCH-7 and record why each applies.
3. Draft commands, args, flags, and output roles for the planned release.
4. Define applicable output, error, mutation, and compatibility contracts before code (CLI-99).
5. Specify help, configuration, env vars, and interaction controls.
6. For a TUI, identify shared application operations and decide which need CLI parity for the named users (TUI-1, TUI-2). Record terminal channels, lifecycle, and accessibility decisions.
7. Give in-scope rules statuses and specify tests for promised behavior.

Use one document scaled to the work: users/scope, architecture decisions, commands/contracts, help/configuration, TUI decisions if any, test plan, and checklist. A small tool may need only a short design.

Done when planned inputs, output formats/schemas, errors, and interaction are specified; required TUI parity is mapped; and in-scope decisions have no unresolved `fail` or `open`. Native payloads need format contracts, not invented JSON schemas.

### Implement a CLI

1. Use the scoped design, filling any missing decisions first.
2. Read applicable language/stack guidance and verify version-sensitive assumptions.
3. Build the contract first with input/output, error, and mutation tests.
4. Review the scope set. Resolve in-scope `fail` and `open` items, or record justified overrides as `waived` under the rubric.

Done when scoped behavior exists, no in-scope `fail` or `open` remains, required available tests pass, and waivers/evidence gaps are explicit. An unavailable platform check remains `unverified`; do not claim that platform verified.

### Extend an existing CLI

1. Record the change scope and inspect existing inputs, outputs, exit codes, and compatibility.
2. Read affected reference sections and dependencies.
3. Design the change to preserve contracts or follow migration rules.
4. Revisit architecture capabilities only where affected.
5. Implement with behavior tests and review the in-scope rules.

Done when changed behavior has no unresolved `fail` or `open`, existing contracts remain compatible or have an explicit migration, and verification limits are reported. Unrelated capabilities are not new implementation requirements.

### Review a CLI or a design

1. Define the scope set. Full reviews cover every applicable rule; bounded reviews cover core and matching sections plus dependencies. List exclusions. Pointer lines identify related contracts without forcing unused levels.
2. Gather design text or implementation evidence: help, docs, source, tests, and representative runs. A required decision omitted from an inspected design is `open`. Unavailable material or insufficient evidence to establish behavior is `unverified`; identify the missing check.
3. Before executing, choose disposable state and a bounded harness for commands that mutate, contact external systems, prompt, watch, or spawn children. Existing authorization governs execution. Use source inspection when representative runs are unavailable.
4. Exercise applicable pipe and pseudo-TTY combinations, including independent stdout/stderr redirection. Use `script` or a harness for bounded smoke checks. Interactive tests need scripted input, a deadline, and child cleanup; opening a PTY alone proves neither human presence nor terminal correctness.
5. Assign rule statuses.
6. Write one finding per problem with F1, F2, ...; rule IDs; locations; consequence; evidence/confidence; and a correction. Group related open decisions while retaining distinct defects.
7. Prioritize by harm. Report verdict/evidence limits, status counts, highest risks by finding ID, findings, and the compact checklist.

Done when all in-scope rules are accounted for, `fail`/`open` items have findings, `unverified` items name missing evidence, and exclusions/waivers have reasons. A completed review may retain unverified behavior in its verdict.

### Make a CLI agent-ready

1. Identify agent tasks and the trust boundary, then review applicable command contracts.
2. Fix failures by severity. Add discovery and noninteractive paths where tasks need them.
3. Preserve defaults. Use opt-ins for interaction/presentation changes, not generally useful schemas, validation, or exit behavior.
4. Review and run representative agent tasks again.

Done when agreed tasks have discoverable stable contracts, required interaction can be avoided, destructive actions retain authorization/target checks, and verification gaps are explicit.

## Language references

Language references map shared rules to an implementation stack. They do not mandate that stack or a migration for existing tools.

- For Go implementation or Go-specific review, read [references/go.md](references/go.md). It describes a minimal Cobra recipe and dependency-specific verification guidance.

## Sources

- S1: Command Line Interface Guidelines (clig.dev), https://clig.dev/
- S2: Building Great CLIs (BK's Digital Garden), https://digitalgarden.bhekani.com/building-great-cl-is/, and the linked notes of the same digital garden
- S3: Anthropic, Writing effective tools for agents - with agents, https://www.anthropic.com/engineering/writing-tools-for-agents
- S4: InfoQ, Keep the Terminal Relevant: Patterns for AI Agent Driven CLIs, https://www.infoq.com/articles/ai-agent-cli/
- S5: Ink and Switch, Local-first software: you own your data, in spite of the cloud, https://www.inkandswitch.com/essay/local-first/
- S6: Simon Willison, Large Language Models can run tools in your terminal with LLM 0.26, https://simonwillison.net/2025/May/27/llm-tools/
- S7: Ratatui documentation, https://ratatui.rs/
- S8: Bubble Tea documentation (Charmbracelet), https://github.com/charmbracelet/bubbletea
- S9: leg100, Tips for building Bubble Tea programs, https://leg100.github.io/en/posts/building-bubbletea-programs/
- S10: Sampath, Merrick, Macvean, Accessibility of Command Line Interfaces, CHI 2021, https://research.google/pubs/accessibility-of-command-line-interfaces/
- S11: GitHub, Building a more accessible GitHub CLI, https://github.blog/engineering/user-experience/building-a-more-accessible-github-cli/
- S12: Cobra documentation (user guide, shell completions, Active Help), https://cobra.dev/ and https://github.com/spf13/cobra
- S13: fang (Charmbracelet), https://github.com/charmbracelet/fang
- S14: koanf, https://github.com/knadh/koanf
- S15: Charmbracelet library docs (Bubble Tea, Bubbles, Lip Gloss, huh, log, colorprofile, Glamour), https://github.com/charmbracelet
- S16: Go documentation, https://go.dev/doc/ and https://pkg.go.dev/
- S17: testscript (go-internal), https://pkg.go.dev/github.com/rogpeppe/go-internal/testscript
- S18: GoReleaser documentation, https://goreleaser.com/
- S19: Go linters: golangci-lint, https://golangci-lint.run/, and staticcheck, https://staticcheck.dev/

Sources explain the guidance; local applicability and contracts govern this skill. Recommendations may be adapted for other command roles. Resolve contradictions here explicitly rather than inferring precedence from a changing external page.

S1 is licensed CC-BY-SA-4.0. These rules paraphrase it.

## Maintaining rule IDs

- Use a separate sequence for each defining file: CORE in SKILL.md, ARCH in arch.md, CLI in cli.md, TUI in tui.md, and GO in go.md.
- Start each sequence at 1, with no leading zeros, for example CORE-1.
- A citation uses the defining file's prefix, even when it appears in another file.
- Append new rules after the highest number in their namespace. Never renumber or reuse an ID.
- Keep a removed rule's ID in place, marked "Retired" with the reason.
- Give a new rule file its own unique prefix.
- Write one rule per bullet: bold ID, rule text, then source tags in backticks.

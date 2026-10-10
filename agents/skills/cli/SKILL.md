---
name: cli
description: Use when designing, building, extending, or reviewing a command-line tool (CLI) or its full-screen terminal UI (TUI), or making one usable by agents. Covers flags, subcommands, help, output, errors, exit codes, config, and program structure: daemons, protocols, and many clients.
---

# CLI rules

## Purpose

This skill gives one rule set for command-line tools that people, agents, and scripts use. Cite each rule by its stable ID, for example "REF-8", in designs, findings, reviews, and commit messages.

This file defines REF-1 to REF-13, the core rules.

## Other rules

Read [references/cli.md](references/cli.md) and [references/architecture.md](references/architecture.md) in full before the Design, Implement, and Extend workflows and before a full review. cli.md holds REF-14 to REF-153, the rules for CLI behavior. architecture.md holds REF-154 to REF-235, the rules for the structure of the program. The L0 rules in architecture.md apply to every CLI, and its Mutation pipeline rules apply to every CLI with mutations.

When the CLI has or plans a full-screen TUI, read [references/tui.md](references/tui.md) in full before any workflow. A review limited to topics outside the TUI skips it. tui.md holds REF-236 to REF-286, the rules for full-screen TUIs.

For a review that the user limits to cli.md topics (for example "flags"), architecture.md is out of scope.

## Terms

These terms apply in all files:

- **Agent**: an AI agent that runs the CLI with no person at the keyboard.
- **Script**: a CI job or shell script that runs the CLI.
- **TTY**: an interactive terminal on a stream (stdin, stdout, or stderr).
- **Machine output**: output from `--json` or `--plain`.
- **Contract**: machine output, the stream it goes to, and exit codes. Agents and scripts depend on it.
- **Mutation**: a command that changes local or remote state.
- **Agent opt-in**: agent support that a flag or env var turns on. Defaults stay human-first.

## Core rules

- **REF-1** Design for humans first, and serve agents and scripts from the same commands through agent opt-ins and non-TTY behavior. clig.dev asks this for commands that people mainly use, and this skill applies it to every CLI. This rule fails when agent or script support changes a human default. `[S1,S2,S3,S4]`
- **REF-2** Send the primary result and machine output to stdout, and send logs, progress, and errors to stderr. A pipe then carries only the result. Errors go to stderr also with `--json` (REF-59). `[S1,S2]`
- **REF-3** Exit with 0 on success and non-zero on failure, with distinct codes for the most important failure modes. REF-62 gives the default code map. `[S1,S2,S4]`
- **REF-4** Show help for `-h` and `--help` on every command and subcommand, and use these flags only for help. Make `-h` work at the end of any command line, and ignore the other flags and args. `[S1]`
- **REF-5** Use the standard flag name when one exists, and give every flag a full-length version. REF-67 lists the standard names. `[S1]`
- **REF-6** Offer `--json` with formatted JSON on every command that prints output, and keep human output the default, even when stdout is not a TTY. Agents and scripts opt in with `--json`. `[S1,S2,S4]`
- **REF-7** Treat machine output as a contract from its first release, with stable field names, types, and streams. Human output may change, so tell script users to pass `--plain` or `--json`. `[S1,S2,S4]`
- **REF-8** Accept every input as a flag or arg, and prompt only when stdin is a TTY and `--no-input` is not set. When input is required and prompts are off, fail and name the flag that supplies it. `[S1,S2,S4]`
- **REF-9** Confirm before dangerous actions: on a TTY, ask for `y` or `yes`. When prompts are off, require `-f, --force`. For a severe action that asks for a typed name (REF-97), require `--confirm="name"` instead. `[S1,S2]`
- **REF-10** Treat `--no-input` as "nothing interactive" (no prompts, no pager), and never as a yes. A needed confirmation then fails the command, and the error names `--force` or `--confirm`. `[S1,S4]`
- **REF-11** Catch expected errors and rewrite them as short messages that say how to fix the problem. Keep stack traces and internal codes for debug output (REF-60). `[S1,S3]`
- **REF-12** Turn off color on a stream when it is not a TTY (REF-36), when `NO_COLOR` is set and not empty, when `TERM=dumb`, or when the user passes `--no-color`. `[S1,S2,S4]`
- **REF-13** Accept secrets only through files (for example `--password-file`), stdin, pipes, a Unix socket or other IPC, or a secret manager. Do not accept them through flags or env vars, because these leak into `ps` output, shell history, and logs. `[S1]`

## REF statuses

Give every REF in scope one status:

- `pass`: the CLI or design meets the rule.
- `fail`: the CLI or design breaks the rule. For a built CLI, a missing behavior that the rule requires is also a `fail`.
- `open`: a design draft does not address the rule yet.
- `n/a`: the rule does not apply, or its condition is false (for example "If you collect telemetry" when there is none). Give a short reason.
- `waived`: the rule applies, but the user, a constraint, or a good reason overrides it. Give the reason.

A rule, or part of a rule, that says "Consider" is optional. It passes when the CLI does it. In a draft that records no decision, mark it `open`. Otherwise judge a skip by the rule's reason sentence, which names a harm to avoid or a benefit to gain. Mark the skip `pass` when a stated reason answers that sentence, or when the harm cannot occur or the benefit does not matter for this CLI. Mark it `fail` when the harm can occur or the benefit is lost, and no reason answers it. When the rule has no reason sentence, a skip passes.

Edge cases:

- A design choice that makes a rule impossible is a `fail`, even if the draft does not mention the rule.
- An optional ("Consider") rule that the design implements but implements wrongly is a `fail`.
- A conditional rule (for example "When the TUI suspends ...") is `n/a` only when its condition is false. When the condition holds, the rule applies. A required rule is then judged as usual, and an optional rule stays optional.
- When the level decision is `open`, the rules of every level that may apply are `open`, not `n/a`.
- A pointer line in tui.md ("Core rules", "CLI-facing rules", "Structure rules") that names an architecture.md REF does not override that REF's "Applies at" line.
- A draft that defers the CLI fails REF-236. Group the `open` rules that follow from the missing CLI into one finding that points to the REF-236 finding.
- Group the `open` rules of one section into one finding, in every file. For a draft that leaves out whole sections, one finding may cover the `open` rules of several sections in one file. A finding may cite `fail` and `open` REFs together.
- A finding may list several locations.

Only clig.dev's Basics are essential: REF-2, REF-3, and REF-19. Any other rule may be waived for a good reason.

To keep a checklist short, one line may cover a run of REFs with the same status, for example `REF-133 to REF-137: n/a (no telemetry)`. Every REF in scope still needs a status.

## Fix order

Sort findings and fix fails in this order: core rules, then the cli.md sections Output contract, Interactivity, Safe changes, Errors and exit codes, Agent discovery, and Testing, then the architecture.md sections in file order, then the tui.md sections in file order, then the other cli.md sections in file order, then the go.md sections in file order. For an architecture-scoped review, put the architecture.md sections right after the core rules. Put all `fail` findings first, then all `open` findings. Inside each group, sort a finding by its highest-priority REF, and use REF order inside one section.

## Workflows

### Design a new CLI

1. List the users (people, agents, scripts) and their high-impact tasks. When agents or scripts are among them, treat the docs as naming them for REF-96.
2. Choose the architecture levels with "Choose a level" in architecture.md (REF-154 to REF-160), and record the level decision as that file describes.
3. Draft the command tree, args, and flags. Shape commands around the tasks.
4. Define the contract before code (REF-112).
5. Define help text, config, env vars, and agent opt-ins.
6. If a TUI is planned, plan it as a client program of the domain core (REF-236), and map each durable action (see tui.md Terms) to a CLI command from step 3 (REF-237).
7. Give every REF a status.

Write the design as one document with these sections: users and tasks, architecture level, command tree, contract, help text, config and env vars, TUI plan (only if a TUI is planned), test plan, REF checklist. The TUI plan lists the CLI command for every durable action, the terminal modes the TUI turns on (REF-239), and the accessible mode decision (REF-277).

Done when the design names every command, flag, env var, and exit code, includes help text and the `--json` schema for each command that prints output, names a CLI command for every durable action in the TUI plan when a TUI is planned, and gives every REF in the files you read a status other than `fail` or `open`.

### Implement a CLI

1. Start from a finished design. If there is none, run the design workflow first.
2. Read the language reference for the CLI's language, if one exists (see Language references), for example go.md for a Go CLI.
3. Build the contract first (REF-112).
4. Add tests for the contract and the schema, and for the dry-run selection when a dry run exists (REF-146).
5. Run the review workflow on the result.

Done when every command in the design exists and its tests pass, the review shows no `fail` on any core rule, and every other `fail` is fixed or `waived` with a reason.

### Extend an existing CLI

Use this workflow to add or change a command, a flag, or a TUI feature, or to add a TUI.

1. Read the language reference for the CLI's language, if one exists (see Language references), for example go.md for a Go CLI.
2. Read the current command tree, flags, `--json` schemas, and exit codes.
3. Design the new or changed command to match them (REF-79, REF-80).
4. Run the level tests for the change (REF-154 to REF-160), and record any level it adds.
5. Build it contract first (REF-112), with tests.
6. Give a status to every REF in scope: the core rules, "Choose a level", and every rule in the cli.md, architecture.md, and language reference sections that the change touches. When the change adds or changes a TUI, also give a status to every tui.md rule.

Done when the new or changed command has no `fail` or `open` on any REF in scope in the files you read, and existing contracts stay unchanged or change only by the Future-proofing rules.

### Review a CLI or a design

1. Read the language reference for the CLI's language, if one exists (see Language references), for example go.md for a Go CLI.
2. Set the scope. Review every rule by default. When the user limits the scope (for example "flags"), check the core rules and every rule in the matching sections, language reference sections included, and list the sections you skip. An "architecture" scope means every architecture.md rule plus the REFs in its "CLI-facing rules" lines. A "TUI" scope means every tui.md rule plus the REFs in its pointer lines. When the user excludes a topic, mark the core rules on that topic `waived` with the reason "outside the requested scope".
3. Collect evidence. For a design draft, use the spec text. For a built CLI, use `--help` for every command, docs, source, and runs.
4. For a built CLI, run commands through a pipe and on a pseudo-TTY: `script -q /dev/null <cmd>` (macOS) or `script -qc '<cmd>' /dev/null` (Linux). When `script` fails because stdin is a socket (as in some agent shells), append `</dev/null` (checked on macOS only): the command then reads end of input, and the output starts with `^D`. When `script` still fails, use a pseudo-TTY from a test harness (in a Go test, creack/pty, or Python's `pty` module). When no TTY run is possible, read the TTY logic in the source, and say so in the report. A TUI cannot run under `script` without input. Review a TUI from the source, or with a scripted key sequence when the TUI supports one, and say which in the report.
5. Give every REF in scope a status. A section whose "Applies at" line rules it out may get `n/a` for all its REFs without a full read. For a draft, mark a rule that the draft does not address `open`, not `fail`, unless a design choice makes the rule impossible (see REF statuses).
6. Write one finding per problem, with a code (F1, F2, ...), one or more REF IDs, one or more locations, and a fix. A location is `file:line` or a spec section. For missing content, write `(missing)` and the section where it belongs. Group `open` rules as "REF statuses" says. Example: `F1 REF-2 cmd/list.go:42: progress goes to stdout. Fix: write progress to stderr.`
7. Sort the findings by the fix order.
8. Write the report in this order: summary (verdict, count of REFs per status, top three risks), findings, REF checklist. The top three risks are the three findings with the largest harm, by finding code, not the first three in fix order. Each checklist line with `fail` or `open` names its finding codes.

Done when every REF in scope in the files you read has a status, every `fail` and `open` has a finding with a location and a fix, every `n/a` and `waived` has a reason, and the report lists any skipped sections.

### Make a CLI agent-ready

1. Run the review workflow on the full scope.
2. Fix the fails in the fix order.
3. Add every agent feature as an agent opt-in (REF-1).
4. Run the review workflow again.

Done when the second review shows no `fail` on any core rule or on any rule in the six cli.md sections that the fix order names, and every other `fail` is fixed or `waived` with a reason.

## Language references

Language references in `references/` map existing REF IDs to code for one language and its libraries. They may add language rules with new IDs. Available files:

- When the CLI is written in Go, read [references/go.md](references/go.md) after the other references. go.md holds REF-287 to REF-330, the Go rules: library defaults that break a REF, and the Go patterns and tooling that the REFs need.

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

S1 wins every conflict. S2 to S19 add rules where S1 is silent, or add agent opt-ins where an S1 default would block agent use. The S1 default then stays.

S1 is licensed CC-BY-SA-4.0. These rules paraphrase it.

## Maintaining REF IDs

- Use one global sequence across all files.
- After release, only append. Never renumber or reuse an ID.
- Keep a removed rule's ID in place, marked "Retired" with the reason.
- State each file's REF range near its top.
- Start a new file's IDs after the highest ID in use.
- Write one rule per bullet: bold ID, rule text, then source tags in backticks.

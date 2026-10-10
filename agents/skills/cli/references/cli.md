# CLI rules: REF-14 to REF-153

This file holds the language-neutral rules for designing, building, and reviewing a CLI. It defines REF-14 to REF-153. The sections follow clig.dev topic order, with added sections for Output contract, Safe changes, Agent discovery, and Testing. The core rules, terms, REF statuses, and fix order live in SKILL.md.

## Principles

Core rules: REF-1 (in SKILL.md).

- **REF-14** Build small, modular commands that use standard streams, signals, and exit codes. People will combine them in ways you did not plan. `[S1]`
- **REF-15** Follow existing CLI conventions. Break one only on purpose, when following it clearly hurts usability. `[S1]`
- **REF-16** Say just enough: show that work is happening, and keep detail for debug output (`-d, --debug`). Silence and floods of output both leave users lost. `[S1]`
- **REF-17** Treat the CLI as a conversation: make features easy to discover, suggest corrections and next steps, and show intermediate state in multi-step work. `[S1]`
- **REF-18** Write output and errors as if you are on the user's side and want them to succeed. `[S1]`

## Basics

Core rules: REF-2, REF-3 (in SKILL.md).

- **REF-19** Use an argument parsing library for args, flags, help text, and spelling suggestions. `[S1]`
- **REF-20** Make the default behavior right for most users, and ship working defaults so first use needs no setup. Power users can override the defaults. `[S1,S2]`

## Help

Core rules: REF-4 (in SKILL.md).

- **REF-21** When a command needs args and gets none, show concise help: a description, one or two examples, key flags, and a pointer to `--help`. Skip this for a command that is interactive by default. `[S1]`
- **REF-22** For git-like tools, also show help for `app help` and `app help sub`. `[S1,S2]`
- **REF-23** Lead help with examples of common and complex uses, and list the most common flags and commands first. Move long example lists to a cheat sheet or web docs. `[S1]`
- **REF-24** Consider building examples as a series from simple to complex uses. Show the actual output when it helps and is short. `[S1]`
- **REF-25** Use formatting in help, such as bold headings, so it is easy to scan. `[S1]`
- **REF-26** Make help formatting terminal-independent, with no escape codes when piped, and keep its structure regular. Agents and scripts can then parse it. `[S1,S2]`
- **REF-27** Include a support path (website or issue tracker) and links to web docs in help. Link directly to a subcommand's page or anchor when one exists. `[S1]`
- **REF-28** When input is wrong, suggest the likely intended command, for example `brew upgrade jq` for `brew update jq`. You may offer to run it, but only on a TTY. `[S1]`
- **REF-29** Avoid running a guessed correction silently, most of all when it changes state. If the tool accepts the mistyped form, support and document that form long term. `[S1]`
- **REF-30** When a command expects piped input but stdin is a TTY, show help and exit, or print a message to stderr. A command that waits for input looks hung. `[S1]`
- **REF-31** Write help as if for a new teammate: state input formats, special terms, and how resources relate. Agents load help text into their context. `[S3]`
- **REF-32** List the tool's own env vars in an "Environment" section of `--help`. `[S4]`

## Documentation

- **REF-33** Provide web docs that people can search and link to. `[S1]`
- **REF-34** Provide terminal docs that match the installed version, and let the tool show them (for example `app help <topic>`). Consider man pages as well. `[S1]`
- **REF-35** When a mutation has a dry run, pair its documented example with the dry-run form. `[S2]`

## Output

Core rules: REF-6, REF-12 (in SKILL.md).

- **REF-36** Check separately whether stdout and stderr are TTYs, and use each result to choose color and layout for that stream. Animations follow REF-44. `[S1]`
- **REF-37** Offer `--plain` with one record per line when human formatting (tables, wrapped cells) would break `grep` and other line tools. `[S1]`
- **REF-38** Consider `--format` with values such as `table`, `json`, and `ndjson` when a command needs more than one machine format. Keep `--json` as the standard name, and use `ndjson` for streams. `[S2]`
- **REF-39** Print brief output on success, say what changed when state changes, and offer `-q` to hide non-essential output. `[S1]`
- **REF-40** Make current state easy to see, for example with a status command for resources the tool owns, and suggest commands to run next. Agents check results with follow-up commands, not only exit codes. `[S1,S4]`
- **REF-41** Make actions that cross the program boundary explicit: reading or writing files not given as args, and calling remote servers. Internal cache files are exempt. `[S1]`
- **REF-42** Consider compact, scannable formats (like the `ls` permission string), and symbols or emoji where they add clarity without clutter. `[S1]`
- **REF-43** Use color with intention and sparingly (for example red for errors), and do not rely on color alone for meaning. Agents cannot read color. `[S1,S4]`
- **REF-44** Show animations, such as spinners and progress bars, only when stdout is a TTY. CI logs then stay readable. `[S1]`
- **REF-45** Show developer-only details only in debug output (`-d, --debug`), and print stderr messages without log-level labels (`ERR`, `WARN`) by default. `[S1]`
- **REF-46** Page long output only when stdin or stdout is a TTY, honor `PAGER`, and use `less -FIRX` as the default options. These options skip paging for one screen, ignore case in search, keep color, and leave the text on screen. `[S1]`
- **REF-47** Show only high-signal fields in default human output, and keep low-level fields (raw UUIDs, MIME types) for `--json` or a detailed mode. Agents that need fewer tokens use the controls in REF-48. `[S3]`
- **REF-48** Keep format and amount as separate controls: `--json` and `--plain` choose the format, and `-q` and debug output (`-d, --debug`) choose the amount. Consider a detail level or field selection for agents that need fewer tokens. `[S1,S3]`
- **REF-49** Offer search, filter, and limit options (for example `--limit`) on commands that can return many records. Agents pay for every line in tokens and time. `[S3,S4]`
- **REF-50** Say when output is cut, and say how to get the rest or narrow the query. `[S3]`
- **REF-51** Consider a default size cap on list and search commands only, and send complete output everywhere else. S3 caps all responses, and this skill narrows that to list and search. `[S3]`

## Output contract

Core rules: REF-7 (in SKILL.md).

- **REF-52** Version structured output with a field such as `schema_version`. Treat additive changes (new optional fields) as safe, and bump the major version for breaking changes (REF-107). `[S2,S4]`
- **REF-53** Publish an explicit schema (JSON Schema or CUE) with examples for every structured output, in a documented location. Cover optional fields, error shapes, and nesting. `[S2,S4]`
- **REF-54** Treat a move of any output to another stream as a breaking change (REF-106). Consumers redirect stdout and stderr separately. `[S4]`
- **REF-55** Use stable identifiers in structured output, and show a readable name next to each ID. Prefer type-prefixed IDs such as `msg_01HXYZ`. `[S2,S3]`
- **REF-56** Fail with a clear error when the tool or a consumer meets an unknown or incompatible schema or state version. `[S2,S4]`

## Errors and exit codes

Core rules: REF-3, REF-11 (in SKILL.md).

- **REF-57** Keep error output high signal. Consider grouping repeated errors of one type under one explanatory header. `[S1]`
- **REF-58** Put the most important information at the end of human error output. Users look there first. `[S1]`
- **REF-59** When `--json` is set, write each error to stderr as a JSON object with a stable error code and a message. `[S1,S2]`
- **REF-60** For unexpected errors, give debug output and steps to report the bug. Consider writing the traceback to a debug log file instead of the terminal. `[S1]`
- **REF-61** Make bug reports easy, for example with a URL that pre-fills the details. `[S1]`
- **REF-62** Use the exit code map below as the default, and document it. clig.dev gives no numbers, so the map comes from S2 and S4. `[S2,S4]`
- **REF-63** Document every exit code, and keep codes stable across minor versions. `[S4]`

Default exit code map (REF-62):

| Code | Meaning |
|---|---|
| 0 | Success |
| 1 | Runtime error |
| 2 | Usage error: bad args or flags |
| 3-125 | Tool-specific errors, one code for each important failure mode (REF-3) |

## Arguments and flags

Core rules: REF-5, REF-13 (in SKILL.md).

- **REF-64** Prefer flags to positional args. Flags are clearer and easier to extend. `[S1]`
- **REF-65** Keep args to one kind of thing: one arg, or several of the same kind, as in `rm a b`. Args with different meanings fit only a common primary action, as in `cp <src> <dst>`. `[S1]`
- **REF-66** Reserve one-letter flags for common flags, most of all at the top level. This keeps short flags free for future flags. `[S1]`
- **REF-67** Use these standard names: `-a, --all`, `-d, --debug` (debug output), `-f, --force`, `--json`, `-h, --help`, `-n, --dry-run`, `--no-input`, `-o, --output` (output file, never a format), `-p, --port`, `-q, --quiet`, `-u, --user`, `--version`. `[S1]`
- **REF-68** Give `-v` one clear meaning: use `-d` for debug output and `-v` for version, or leave `-v` unused. `[S1]`
- **REF-69** Give unambiguous names to flags that have no standard name, for example `--user-id` for an ID. Keep `-u, --user` where it has the standard meaning. `[S3]`
- **REF-70** Support `-` to read from stdin or write to stdout when input or output is a file. Consider accepting JSON on stdin for structured input. `[S1,S2]`
- **REF-71** When a flag takes an optional value, accept a special word such as `none` for "no value". A blank value makes it unclear which word is the flag value and which is an arg. `[S1]`
- **REF-72** Make args, flags, and subcommands order-independent where you can. Users often recall the last command and add a flag at the end. `[S1]`
- **REF-73** Give each flag one job. A flag that skips confirmation must not also choose the action. `[S2]`
- **REF-74** Read a secret file inside the tool, through a flag such as `--password-file`. A shell form such as `--password $(< file)` still puts the secret in a flag. `[S1]`

## Interactivity

Core rules: REF-8, REF-10 (in SKILL.md).

- **REF-75** Prompt for a missing arg or flag when stdin is a TTY, within the limits of REF-8. `[S1]`
- **REF-76** Hide a password while the user types it by turning off terminal echo. `[S1]`
- **REF-77** Make it clear how to exit, and keep Ctrl-C working during network I/O. For wrappers where Ctrl-C cannot quit (ssh, tmux), document the escape key. `[S1]`

## Subcommands and command design

- **REF-78** Consider subcommands to split a complex tool or to group closely related tools. Share global flags, help, and config across them. `[S1]`
- **REF-79** Use the same flag names and output formats for the same things across subcommands, including scope selectors such as `--account` or `--profile` on every sibling. Hidden default scopes let agents act on the wrong target. `[S1,S2]`
- **REF-80** When the tool has many kinds of objects and operations, consider two levels of subcommands, for example `noun verb` (the more common form). Keep the names and verbs consistent across object types, as in `docker container create`. `[S1,S3]`
- **REF-81** Give commands names that are easy to tell apart. `update` next to `upgrade` confuses users. `[S1]`
- **REF-82** Give each command one clear, distinct purpose. Overlapping commands make agents pick the wrong one. `[S2,S3]`
- **REF-83** Build a few commands for high-impact workflows first, rather than one command for each API endpoint. `[S3]`
- **REF-84** Combine steps that people and agents often chain into one command, and let one command gather related context in place of many get and list calls. `[S3]`
- **REF-85** Make the CLI the complete surface: every product feature, including features in a GUI, TUI, or agent skill, must be reachable through a public subcommand. `[S2]`

## Robustness

- **REF-86** Validate input early and strictly, and stop with a clear error before anything changes. `[S1,S3]`
- **REF-87** Print something within 100ms, and print a message before a network call. A quick response matters more than total speed. `[S1]`
- **REF-88** Show progress for long work: a spinner, bar, or time estimate when stdout is a TTY (REF-44), and plain progress lines on stderr otherwise. `[S1,S4]`
- **REF-89** Run work in parallel where it helps, and keep parallel output robust and free of interleaving. Use a library for it where you can. `[S1]`
- **REF-90** When an error happens behind a progress bar, print the hidden logs. `[S1]`
- **REF-91** Give network calls a timeout with a sensible default that users can configure. `[S1]`
- **REF-92** Make commands recoverable: a rerun after a transient failure continues where it stopped. `[S1]`
- **REF-93** Design crash-only: defer cleanup so the program can exit at once on failure, and expect to start after a run whose cleanup never happened. `[S1]`
- **REF-94** Expect misuse: wrapper scripts, bad networks, parallel instances, and odd environments such as case-insensitive filesystems. `[S1]`
- **REF-95** Keep code and special cases simple, and make commands deterministic. Callers can then predict the next step. `[S1,S4]`

## Safe changes

Core rules: REF-9, REF-10 (in SKILL.md).

REF-96 decides when a command needs a dry run. Once a command has one, REF-99 to REF-102, REF-105, and REF-146 apply in full.

- **REF-96** Offer `-n, --dry-run` on every mutation when the CLI's docs name agents or scripts as users, and consider it for complex or risky changes otherwise. A dry run shows exactly what would change without changing it. `[S1,S2,S4]`
- **REF-97** Match confirmation to the danger level in the table below, and make severe actions hard to confirm by accident. When a severe action asks for a typed name, offer `--confirm="name"` so it stays scriptable. `[S1]`
- **REF-98** Treat non-obvious data loss as severe, for example a lowered config limit that deletes items. `[S1]`

Danger levels (REF-97), with clig.dev's examples:

| Level | Example | Confirmation |
|---|---|---|
| Mild | Delete a file | Optional. A command named `delete` may need none. |
| Moderate | Delete a directory or a remote resource, or make a bulk change that is hard to undo | Prompt. Consider a dry run. |
| Severe | Delete a whole remote app or server | Prompt. Consider asking the user to type the resource name. |

- **REF-99** Build the plan once and pass it to both paths: `--dry-run` renders it, and the real run renders it and then applies it. Preview and execution then share one selection and one code path. `[S2]`
- **REF-100** Store the action mode, destination, and scope in the plan. Resolve each value once, and use that same value for validation, preview, and execution. In one real case, a dry run said "save draft" while the real run sent mail. `[S2]`
- **REF-101** Ask for confirmation after the plan is built and before the mutation starts. `[S2]`
- **REF-102** State that a preview shows what the tool will attempt, not what a remote service will accept. `[S2]`
- **REF-103** Make operations idempotent where possible, for example with idempotency keys or natural deduplication on writes. Agents retry. `[S1,S2,S4]`
- **REF-104** Offer an early check that validates input without running it, such as a syntax-check mode, before destructive actions. `[S4]`
- **REF-105** Return a meaningful exit code from a dry run, so callers know whether it is safe to proceed. `[S4]`

## Future-proofing

- **REF-106** Change an interface (subcommands, args, flags, config files, env vars, structured output) only after a lengthy, documented deprecation. Scripts and agents break more easily than people do, so weigh it before you remove anything. `[S1,S4]`
- **REF-107** Keep breaking changes rare, even with semantic versioning. A major version bump every month makes the version number meaningless. `[S1]`
- **REF-108** Keep changes additive, for example add a new flag in place of changing an old one, as long as the interface does not bloat. `[S1,S4]`
- **REF-109** Before a non-additive change, warn inside the program and say how to migrate (ship a migration path when you can). Stop the warning once usage has changed. `[S1,S4]`
- **REF-110** Require full subcommand names, and keep aliases explicit and stable. A catch-all subcommand or prefix matching blocks new commands later. `[S1]`
- **REF-111** Make sure the tool still runs in 20 years without external services. Never block on an analytics call. `[S1]`
- **REF-112** Define the output schema, error model, and versioning rule before code. With the first mutation, add `--dry-run` when REF-96 requires it, and `--force` when REF-9 requires it. `[S2]`
- **REF-113** Version any state the tool writes, and upgrade older state when you can. Consider tracking state lineage, so local state never overwrites newer remote state. `[S4]`

## Signals

- **REF-114** Exit as soon as possible on Ctrl-C (SIGINT), and print a message right away, before cleanup. `[S1]`
- **REF-115** Put a timeout on cleanup, let a second Ctrl-C skip it, and say what the second Ctrl-C will do. `[S1]`
- **REF-116** Handle SIGTERM with cleanup that leaves state consistent. `[S4]`

## Configuration

- **REF-117** Use flags for settings that change per run, and flags plus env vars for settings that are stable per user or machine. Consider a config file only when env vars are not enough. `[S1]`
- **REF-118** Keep project-wide settings in a command-specific, version-controlled file. `[S1]`
- **REF-119** Follow the XDG Base Directory spec for config locations. It keeps config in `~/.config` in place of many dotfiles in the home directory. `[S1]`
- **REF-120** Ask before you change config that belongs to another program, and say exactly what you change. Prefer a new file over appending, and mark edits to shared files with a dated comment. `[S1]`
- **REF-121** Apply this precedence, highest first: flags, env vars from the shell, project config (for example `.env`), user config, system config. `[S1,S4]`

## Environment variables

Core rules: REF-13 (in SKILL.md).

- **REF-122** Use env vars for behavior that depends on where the command runs, such as a profile set once for a whole session. `[S1,S4]`
- **REF-123** Name env vars with uppercase letters, digits, and underscores, with a letter or underscore first, and prefix your own vars with the tool name (for example `MYAPP_PROFILE`, `MYAPP_NO_COLOR`). `[S1,S4]`
- **REF-124** Keep env var values on a single line. Multi-line values cause problems with the `env` command. `[S1]`
- **REF-125** Leave widely used names, such as POSIX standard vars, to their existing meaning. `[S1]`
- **REF-126** Honor the common vars: `NO_COLOR`, `FORCE_COLOR`, `DEBUG`, `EDITOR`, `HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY`, `NO_PROXY`, `SHELL`, `TERM`, `TERMINFO`, `TERMCAP`, `TMPDIR`, `HOME`, `LINES`, and `COLUMNS`. `[S1]`
- **REF-127** Read env vars from a local `.env` file for per-directory settings. Use a real config file for anything beyond that. `[S1]`

## Naming

- **REF-128** Pick a simple, memorable name that is specific, not generic. `[S1]`
- **REF-129** Use only lowercase letters in the name, and dashes only if you must. `[S1]`
- **REF-130** Keep the name short, easy to type, and distinct from common utilities. `[S1]`

## Distribution

- **REF-131** Ship a single binary if possible. Otherwise, use the platform's native package installer, so users can remove every file it installed. A language-specific tool, such as a linter, is exempt. `[S1]`
- **REF-132** Make uninstall easy, and put the steps at the end of the install docs. `[S1]`

## Analytics

- **REF-133** Collect usage or crash data only with consent, and prefer opt-in collection (REF-135). `[S1,S4]`
- **REF-134** State exactly what you collect, why, how anonymous it is, and how long you keep it, on the website or at first run. `[S1,S4]`
- **REF-135** Ask users to opt in. If collection is opt-out, announce it and make it easy to turn off, for example with `MYAPP_NO_TELEMETRY=1`, a config setting, and a status command. `[S1,S4]`
- **REF-136** Consider other signals before telemetry: instrument web docs and downloads, and talk to users and newcomers. `[S1,S3]`
- **REF-137** If you collect telemetry with consent (REF-133 to REF-135), count agent usage apart from human and CI usage, and let error and timeout rates set your priorities. `[S4]`

## Agent discovery

- **REF-138** Let agents discover commands, flags, and output shapes without web docs. Consider a `--schema` flag or a `manifest` subcommand that returns structured data. `[S2]`
- **REF-139** Ship agent docs (for example `AGENTS.md` or a skill) with usage examples. `[S2]`
- **REF-140** Consider marking commands that destroy data or reach outside systems, in help and in any schema, so agents see the risk. `[S3]`
- **REF-141** Consider exposing commands through MCP, with input schemas derived from the command definitions, once regression tests exist (REF-147). Keep the CLI the canonical surface, because S2 prefers shell commands over MCP. `[S2,S4]`

## Testing

REF-142 to REF-147 test the CLI and its contract. REF-148 to REF-153 evaluate how well agents use it.

- **REF-142** Test the contract early with a second consumer, such as a shell one-liner through `jq` or a small agent skill. If the output reads badly there, fix the schema. `[S2]`
- **REF-143** Run integration tests against real systems, and check that fake and real backends give the same JSON shape. `[S2]`
- **REF-144** Test every feature through the public CLI. If an agent cannot verify a feature through the CLI, the CLI has a gap. `[S2]`
- **REF-145** Keep fault injection inside the product boundary (app network seam, proxy, container), with isolated scope and postcondition checks. Never change host machine state. `[S2]`
- **REF-146** Verify that the dry-run selection matches what the real run touches, byte for byte. `[S2]`
- **REF-147** Keep regression tests (for example with bats-core) for escape hatches and output formats, and validate output against its schema in CI. `[S4]`
- **REF-148** Prototype the commands, use them yourself, and collect user feedback on real use cases. `[S3]`
- **REF-149** Measure agent use with evaluations: realistic multi-step tasks, each with a verifiable outcome. Run each task in its own simple agent loop, and make the agent state its reasoning before each call. `[S3]`
- **REF-150** Make verifiers accept any correct answer, whatever its formatting or strategy. Consider listing the commands you expect agents to call. `[S3]`
- **REF-151** Record metrics beyond accuracy (runtime, call count, tokens, errors), and use call patterns to find commands to merge. `[S3]`
- **REF-152** Read raw transcripts and agent feedback, including what agents leave out. Many redundant calls suggest new limits or page sizes, and many invalid-argument errors suggest clearer help. `[S3]`
- **REF-153** Measure help text and naming changes with evaluations, and confirm gains on a held-out task set. Consider giving transcripts to a coding agent to refactor commands. `[S3]`

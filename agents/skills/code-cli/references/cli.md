# CLI rules: CLI-1 to CLI-140

This file holds the language-neutral rules for designing, building, and reviewing a CLI. It defines CLI-1 to CLI-140. The sections follow clig.dev topic order, with added sections for Output contract, Safe changes, Agent discovery, and Testing. The core rules, terms, rule statuses, and fix order live in SKILL.md.

## Principles

Core rules: CORE-1 (in SKILL.md).

- **CLI-1** Build small, modular commands that use standard streams, signals, and exit codes. People will combine them in ways you did not plan. `[S1]`
- **CLI-2** Follow existing CLI conventions. Break one only on purpose, when following it clearly hurts usability. `[S1]`
- **CLI-3** Say just enough: show that work is happening, and keep detail for debug output (`-d, --debug`). Silence and floods of output both leave users lost. `[S1]`
- **CLI-4** Treat the CLI as a conversation: make features easy to discover, suggest corrections and next steps, and show intermediate state in multi-step work. `[S1]`
- **CLI-5** Write output and errors as if you are on the user's side and want them to succeed. `[S1]`

## Basics

Core rules: CORE-2, CORE-3 (in SKILL.md).

- **CLI-6** Use an argument parsing library for args, flags, help text, and spelling suggestions. `[S1]`
- **CLI-7** Make the default behavior right for most users, and ship working defaults so first use needs no setup. Power users can override the defaults. `[S1,S2]`

## Help

Core rules: CORE-4 (in SKILL.md).

- **CLI-8** When a command needs args and gets none, show concise help: a description, one or two examples, key flags, and a pointer to `--help`. Skip this for a command that is interactive by default. `[S1]`
- **CLI-9** For git-like tools, also show help for `app help` and `app help sub`. `[S1,S2]`
- **CLI-10** Lead help with examples of common and complex uses, and list the most common flags and commands first. Move long example lists to a cheat sheet or web docs. `[S1]`
- **CLI-11** Consider building examples as a series from simple to complex uses. Show the actual output when it helps and is short. `[S1]`
- **CLI-12** Use formatting in help, such as bold headings, so it is easy to scan. `[S1]`
- **CLI-13** Make help formatting terminal-independent, with no escape codes when piped, and keep its structure regular. Agents and scripts can then parse it. `[S1,S2]`
- **CLI-14** Include a support path (website or issue tracker) and links to web docs in help. Link directly to a subcommand's page or anchor when one exists. `[S1]`
- **CLI-15** When input is wrong, suggest the likely intended command, for example `brew upgrade jq` for `brew update jq`. You may offer to run it, but only on a TTY. `[S1]`
- **CLI-16** Avoid running a guessed correction silently, most of all when it changes state. If the tool accepts the mistyped form, support and document that form long term. `[S1]`
- **CLI-17** When a command expects piped input but stdin is a TTY, show help and exit, or print a message to stderr. A command that waits for input looks hung. `[S1]`
- **CLI-18** Write help as if for a new teammate: state input formats, special terms, and how resources relate. Agents load help text into their context. `[S3]`
- **CLI-19** List the tool's own env vars in an "Environment" section of `--help`. `[S4]`

## Documentation

- **CLI-20** Provide web docs that people can search and link to. `[S1]`
- **CLI-21** Provide terminal docs that match the installed version, and let the tool show them (for example `app help <topic>`). Consider man pages as well. `[S1]`
- **CLI-22** When a mutation has a dry run, pair its documented example with the dry-run form. `[S2]`

## Output

Core rules: CORE-6, CORE-12 (in SKILL.md).

- **CLI-23** Check separately whether stdout and stderr are TTYs, and use each result to choose color and layout for that stream. Animations follow CLI-31. `[S1]`
- **CLI-24** Offer `--plain` with one record per line when human formatting (tables, wrapped cells) would break `grep` and other line tools. `[S1]`
- **CLI-25** Consider `--format` with values such as `table`, `json`, and `ndjson` when a command needs more than one machine format. Keep `--json` as the standard name, and use `ndjson` for streams. `[S2]`
- **CLI-26** Print brief output on success, say what changed when state changes, and offer `-q` to hide non-essential output. `[S1]`
- **CLI-27** Make current state easy to see, for example with a status command for resources the tool owns, and suggest commands to run next. Agents check results with follow-up commands, not only exit codes. `[S1,S4]`
- **CLI-28** Make actions that cross the program boundary explicit: reading or writing files not given as args, and calling remote servers. Internal cache files are exempt. `[S1]`
- **CLI-29** Consider compact, scannable formats (like the `ls` permission string), and symbols or emoji where they add clarity without clutter. `[S1]`
- **CLI-30** Use color with intention and sparingly (for example red for errors), and do not rely on color alone for meaning. Agents cannot read color. `[S1,S4]`
- **CLI-31** Show animations, such as spinners and progress bars, only when stdout is a TTY. CI logs then stay readable. `[S1]`
- **CLI-32** Show developer-only details only in debug output (`-d, --debug`), and print stderr messages without log-level labels (`ERR`, `WARN`) by default. `[S1]`
- **CLI-33** Page long output only when stdin or stdout is a TTY, honor `PAGER`, and use `less -FIRX` as the default options. These options skip paging for one screen, ignore case in search, keep color, and leave the text on screen. `[S1]`
- **CLI-34** Show only high-signal fields in default human output, and keep low-level fields (raw UUIDs, MIME types) for `--json` or a detailed mode. Agents that need fewer tokens use the controls in CLI-35. `[S3]`
- **CLI-35** Keep format and amount as separate controls: `--json` and `--plain` choose the format, and `-q` and debug output (`-d, --debug`) choose the amount. Consider a detail level or field selection for agents that need fewer tokens. `[S1,S3]`
- **CLI-36** Offer search, filter, and limit options (for example `--limit`) on commands that can return many records. Agents pay for every line in tokens and time. `[S3,S4]`
- **CLI-37** Say when output is cut, and say how to get the rest or narrow the query. `[S3]`
- **CLI-38** Consider a default size cap on list and search commands only, and send complete output everywhere else. S3 caps all responses, and this skill narrows that to list and search. `[S3]`

## Output contract

Core rules: CORE-7 (in SKILL.md).

- **CLI-39** Version structured output with a field such as `schema_version`. Treat additive changes (new optional fields) as safe, and bump the major version for breaking changes (CLI-94). `[S2,S4]`
- **CLI-40** Publish an explicit schema (JSON Schema or CUE) with examples for every structured output, in a documented location. Cover optional fields, error shapes, and nesting. `[S2,S4]`
- **CLI-41** Treat a move of any output to another stream as a breaking change (CLI-93). Consumers redirect stdout and stderr separately. `[S4]`
- **CLI-42** Use stable identifiers in structured output, and show a readable name next to each ID. Prefer type-prefixed IDs such as `msg_01HXYZ`. `[S2,S3]`
- **CLI-43** Fail with a clear error when the tool or a consumer meets an unknown or incompatible schema or state version. `[S2,S4]`

## Errors and exit codes

Core rules: CORE-3, CORE-11 (in SKILL.md).

- **CLI-44** Keep error output high signal. Consider grouping repeated errors of one type under one explanatory header. `[S1]`
- **CLI-45** Put the most important information at the end of human error output. Users look there first. `[S1]`
- **CLI-46** When `--json` is set, write each error to stderr as a JSON object with a stable error code and a message. `[S1,S2]`
- **CLI-47** For unexpected errors, give debug output and steps to report the bug. Consider writing the traceback to a debug log file instead of the terminal. `[S1]`
- **CLI-48** Make bug reports easy, for example with a URL that pre-fills the details. `[S1]`
- **CLI-49** Use the exit code map below as the default, and document it. clig.dev gives no numbers, so the map comes from S2 and S4. `[S2,S4]`
- **CLI-50** Document every exit code, and keep codes stable across minor versions. `[S4]`

Default exit code map (CLI-49):

| Code | Meaning |
|---|---|
| 0 | Success |
| 1 | Runtime error |
| 2 | Usage error: bad args or flags |
| 3-125 | Tool-specific errors, one code for each important failure mode (CORE-3) |

## Arguments and flags

Core rules: CORE-5, CORE-13 (in SKILL.md).

- **CLI-51** Prefer flags to positional args. Flags are clearer and easier to extend. `[S1]`
- **CLI-52** Keep args to one kind of thing: one arg, or several of the same kind, as in `rm a b`. Args with different meanings fit only a common primary action, as in `cp <src> <dst>`. `[S1]`
- **CLI-53** Reserve one-letter flags for common flags, most of all at the top level. This keeps short flags free for future flags. `[S1]`
- **CLI-54** Use these standard names: `-a, --all`, `-d, --debug` (debug output), `-f, --force`, `--json`, `-h, --help`, `-n, --dry-run`, `--no-input`, `-o, --output` (output file, never a format), `-p, --port`, `-q, --quiet`, `-u, --user`, `--version`. `[S1]`
- **CLI-55** Give `-v` one clear meaning: use `-d` for debug output and `-v` for version, or leave `-v` unused. `[S1]`
- **CLI-56** Give unambiguous names to flags that have no standard name, for example `--user-id` for an ID. Keep `-u, --user` where it has the standard meaning. `[S3]`
- **CLI-57** Support `-` to read from stdin or write to stdout when input or output is a file. Consider accepting JSON on stdin for structured input. `[S1,S2]`
- **CLI-58** When a flag takes an optional value, accept a special word such as `none` for "no value". A blank value makes it unclear which word is the flag value and which is an arg. `[S1]`
- **CLI-59** Make args, flags, and subcommands order-independent where you can. Users often recall the last command and add a flag at the end. `[S1]`
- **CLI-60** Give each flag one job. A flag that skips confirmation must not also choose the action. `[S2]`
- **CLI-61** Read a secret file inside the tool, through a flag such as `--password-file`. A shell form such as `--password $(< file)` still puts the secret in a flag. `[S1]`

## Interactivity

Core rules: CORE-8, CORE-10 (in SKILL.md).

- **CLI-62** Prompt for a missing arg or flag when stdin is a TTY, within the limits of CORE-8. `[S1]`
- **CLI-63** Hide a password while the user types it by turning off terminal echo. `[S1]`
- **CLI-64** Make it clear how to exit, and keep Ctrl-C working during network I/O. For wrappers where Ctrl-C cannot quit (ssh, tmux), document the escape key. `[S1]`

## Subcommands and command design

- **CLI-65** Consider subcommands to split a complex tool or to group closely related tools. Share global flags, help, and config across them. `[S1]`
- **CLI-66** Use the same flag names and output formats for the same things across subcommands, including scope selectors such as `--account` or `--profile` on every sibling. Hidden default scopes let agents act on the wrong target. `[S1,S2]`
- **CLI-67** When the tool has many kinds of objects and operations, consider two levels of subcommands, for example `noun verb` (the more common form). Keep the names and verbs consistent across object types, as in `docker container create`. `[S1,S3]`
- **CLI-68** Give commands names that are easy to tell apart. `update` next to `upgrade` confuses users. `[S1]`
- **CLI-69** Give each command one clear, distinct purpose. Overlapping commands make agents pick the wrong one. `[S2,S3]`
- **CLI-70** Build a few commands for high-impact workflows first, rather than one command for each API endpoint. `[S3]`
- **CLI-71** Combine steps that people and agents often chain into one command, and let one command gather related context in place of many get and list calls. `[S3]`
- **CLI-72** Make the CLI the complete surface: every product feature, including features in a GUI, TUI, or agent skill, must be reachable through a public subcommand. `[S2]`

## Robustness

- **CLI-73** Validate input early and strictly, and stop with a clear error before anything changes. `[S1,S3]`
- **CLI-74** Print something within 100ms, and print a message before a network call. A quick response matters more than total speed. `[S1]`
- **CLI-75** Show progress for long work: a spinner, bar, or time estimate when stdout is a TTY (CLI-31), and plain progress lines on stderr otherwise. `[S1,S4]`
- **CLI-76** Run work in parallel where it helps, and keep parallel output robust and free of interleaving. Use a library for it where you can. `[S1]`
- **CLI-77** When an error happens behind a progress bar, print the hidden logs. `[S1]`
- **CLI-78** Give network calls a timeout with a sensible default that users can configure. `[S1]`
- **CLI-79** Make commands recoverable: a rerun after a transient failure continues where it stopped. `[S1]`
- **CLI-80** Design crash-only: defer cleanup so the program can exit at once on failure, and expect to start after a run whose cleanup never happened. `[S1]`
- **CLI-81** Expect misuse: wrapper scripts, bad networks, parallel instances, and odd environments such as case-insensitive filesystems. `[S1]`
- **CLI-82** Keep code and special cases simple, and make commands deterministic. Callers can then predict the next step. `[S1,S4]`

## Safe changes

Core rules: CORE-9, CORE-10 (in SKILL.md).

CLI-83 decides when a command needs a dry run. Once a command has one, CLI-86 to CLI-89, CLI-92, and CLI-133 apply in full.

- **CLI-83** Offer `-n, --dry-run` on every mutation when the CLI's docs name agents or scripts as users, and consider it for complex or risky changes otherwise. A dry run shows exactly what would change without changing it. `[S1,S2,S4]`
- **CLI-84** Match confirmation to the danger level in the table below, and make severe actions hard to confirm by accident. When a severe action asks for a typed name, offer `--confirm="name"` so it stays scriptable. `[S1]`
- **CLI-85** Treat non-obvious data loss as severe, for example a lowered config limit that deletes items. `[S1]`

Danger levels (CLI-84), with clig.dev's examples:

| Level | Example | Confirmation |
|---|---|---|
| Mild | Delete a file | Optional. A command named `delete` may need none. |
| Moderate | Delete a directory or a remote resource, or make a bulk change that is hard to undo | Prompt. Consider a dry run. |
| Severe | Delete a whole remote app or server | Prompt. Consider asking the user to type the resource name. |

- **CLI-86** Build the plan once and pass it to both paths: `--dry-run` renders it, and the real run renders it and then applies it. Preview and execution then share one selection and one code path. `[S2]`
- **CLI-87** Store the action mode, destination, and scope in the plan. Resolve each value once, and use that same value for validation, preview, and execution. In one real case, a dry run said "save draft" while the real run sent mail. `[S2]`
- **CLI-88** Ask for confirmation after the plan is built and before the mutation starts. `[S2]`
- **CLI-89** State that a preview shows what the tool will attempt, not what a remote service will accept. `[S2]`
- **CLI-90** Make operations idempotent where possible, for example with idempotency keys or natural deduplication on writes. Agents retry. `[S1,S2,S4]`
- **CLI-91** Offer an early check that validates input without running it, such as a syntax-check mode, before destructive actions. `[S4]`
- **CLI-92** Return a meaningful exit code from a dry run, so callers know whether it is safe to proceed. `[S4]`

## Future-proofing

- **CLI-93** Change an interface (subcommands, args, flags, config files, env vars, structured output) only after a lengthy, documented deprecation. Scripts and agents break more easily than people do, so weigh it before you remove anything. `[S1,S4]`
- **CLI-94** Keep breaking changes rare, even with semantic versioning. A major version bump every month makes the version number meaningless. `[S1]`
- **CLI-95** Keep changes additive, for example add a new flag in place of changing an old one, as long as the interface does not bloat. `[S1,S4]`
- **CLI-96** Before a non-additive change, warn inside the program and say how to migrate (ship a migration path when you can). Stop the warning once usage has changed. `[S1,S4]`
- **CLI-97** Require full subcommand names, and keep aliases explicit and stable. A catch-all subcommand or prefix matching blocks new commands later. `[S1]`
- **CLI-98** Make sure the tool still runs in 20 years without external services. Never block on an analytics call. `[S1]`
- **CLI-99** Define the output schema, error model, and versioning rule before code. With the first mutation, add `--dry-run` when CLI-83 requires it, and `--force` when CORE-9 requires it. `[S2]`
- **CLI-100** Version any state the tool writes, and upgrade older state when you can. Consider tracking state lineage, so local state never overwrites newer remote state. `[S4]`

## Signals

- **CLI-101** Exit as soon as possible on Ctrl-C (SIGINT), and print a message right away, before cleanup. `[S1]`
- **CLI-102** Put a timeout on cleanup, let a second Ctrl-C skip it, and say what the second Ctrl-C will do. `[S1]`
- **CLI-103** Handle SIGTERM with cleanup that leaves state consistent. `[S4]`

## Configuration

- **CLI-104** Use flags for settings that change per run, and flags plus env vars for settings that are stable per user or machine. Consider a config file only when env vars are not enough. `[S1]`
- **CLI-105** Keep project-wide settings in a command-specific, version-controlled file. `[S1]`
- **CLI-106** Follow the XDG Base Directory spec for config locations. It keeps config in `~/.config` in place of many dotfiles in the home directory. `[S1]`
- **CLI-107** Ask before you change config that belongs to another program, and say exactly what you change. Prefer a new file over appending, and mark edits to shared files with a dated comment. `[S1]`
- **CLI-108** Apply this precedence, highest first: flags, env vars from the shell, project config (for example `.env`), user config, system config. `[S1,S4]`

## Environment variables

Core rules: CORE-13 (in SKILL.md).

- **CLI-109** Use env vars for behavior that depends on where the command runs, such as a profile set once for a whole session. `[S1,S4]`
- **CLI-110** Name env vars with uppercase letters, digits, and underscores, with a letter or underscore first, and prefix your own vars with the tool name (for example `MYAPP_PROFILE`, `MYAPP_NO_COLOR`). `[S1,S4]`
- **CLI-111** Keep env var values on a single line. Multi-line values cause problems with the `env` command. `[S1]`
- **CLI-112** Leave widely used names, such as POSIX standard vars, to their existing meaning. `[S1]`
- **CLI-113** Honor the common vars: `NO_COLOR`, `FORCE_COLOR`, `DEBUG`, `EDITOR`, `HTTP_PROXY`, `HTTPS_PROXY`, `ALL_PROXY`, `NO_PROXY`, `SHELL`, `TERM`, `TERMINFO`, `TERMCAP`, `TMPDIR`, `HOME`, `LINES`, and `COLUMNS`. `[S1]`
- **CLI-114** Read env vars from a local `.env` file for per-directory settings. Use a real config file for anything beyond that. `[S1]`

## Naming

- **CLI-115** Pick a simple, memorable name that is specific, not generic. `[S1]`
- **CLI-116** Use only lowercase letters in the name, and dashes only if you must. `[S1]`
- **CLI-117** Keep the name short, easy to type, and distinct from common utilities. `[S1]`

## Distribution

- **CLI-118** Ship a single binary if possible. Otherwise, use the platform's native package installer, so users can remove every file it installed. A language-specific tool, such as a linter, is exempt. `[S1]`
- **CLI-119** Make uninstall easy, and put the steps at the end of the install docs. `[S1]`

## Analytics

- **CLI-120** Collect usage or crash data only with consent, and prefer opt-in collection (CLI-122). `[S1,S4]`
- **CLI-121** State exactly what you collect, why, how anonymous it is, and how long you keep it, on the website or at first run. `[S1,S4]`
- **CLI-122** Ask users to opt in. If collection is opt-out, announce it and make it easy to turn off, for example with `MYAPP_NO_TELEMETRY=1`, a config setting, and a status command. `[S1,S4]`
- **CLI-123** Consider other signals before telemetry: instrument web docs and downloads, and talk to users and newcomers. `[S1,S3]`
- **CLI-124** If you collect telemetry with consent (CLI-120 to CLI-122), count agent usage apart from human and CI usage, and let error and timeout rates set your priorities. `[S4]`

## Agent discovery

- **CLI-125** Let agents discover commands, flags, and output shapes without web docs. Consider a `--schema` flag or a `manifest` subcommand that returns structured data. `[S2]`
- **CLI-126** Ship agent docs (for example `AGENTS.md` or a skill) with usage examples. `[S2]`
- **CLI-127** Consider marking commands that destroy data or reach outside systems, in help and in any schema, so agents see the risk. `[S3]`
- **CLI-128** Consider exposing commands through MCP, with input schemas derived from the command definitions, once regression tests exist (CLI-134). Keep the CLI the canonical surface, because S2 prefers shell commands over MCP. `[S2,S4]`

## Testing

CLI-129 to CLI-134 test the CLI and its contract. CLI-135 to CLI-140 evaluate how well agents use it.

- **CLI-129** Test the contract early with a second consumer, such as a shell one-liner through `jq` or a small agent skill. If the output reads badly there, fix the schema. `[S2]`
- **CLI-130** Run integration tests against real systems, and check that fake and real backends give the same JSON shape. `[S2]`
- **CLI-131** Test every feature through the public CLI. If an agent cannot verify a feature through the CLI, the CLI has a gap. `[S2]`
- **CLI-132** Keep fault injection inside the product boundary (app network seam, proxy, container), with isolated scope and postcondition checks. Never change host machine state. `[S2]`
- **CLI-133** Verify that the dry-run selection matches what the real run touches, byte for byte. `[S2]`
- **CLI-134** Keep regression tests (for example with bats-core) for escape hatches and output formats, and validate output against its schema in CI. `[S4]`
- **CLI-135** Prototype the commands, use them yourself, and collect user feedback on real use cases. `[S3]`
- **CLI-136** Measure agent use with evaluations: realistic multi-step tasks, each with a verifiable outcome. Run each task in its own simple agent loop, and make the agent state its reasoning before each call. `[S3]`
- **CLI-137** Make verifiers accept any correct answer, whatever its formatting or strategy. Consider listing the commands you expect agents to call. `[S3]`
- **CLI-138** Record metrics beyond accuracy (runtime, call count, tokens, errors), and use call patterns to find commands to merge. `[S3]`
- **CLI-139** Read raw transcripts and agent feedback, including what agents leave out. Many redundant calls suggest new limits or page sizes, and many invalid-argument errors suggest clearer help. `[S3]`
- **CLI-140** Measure help text and naming changes with evaluations, and confirm gains on a held-out task set. Consider giving transcripts to a coding agent to refactor commands. `[S3]`

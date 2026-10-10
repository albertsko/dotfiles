# CLI rules

This file holds the language-neutral rules for designing, building, and reviewing a CLI. The sections follow clig.dev topic order. The core rules, terms, rule statuses, and fix order live in SKILL.md.

## Principles

Core rules: CORE-1.

- **CLI-1** Build small, modular commands that use standard streams, signals, and exit codes. People will combine them in ways you did not plan. `[S1]`
- **CLI-2** Follow existing CLI conventions. Break one only on purpose, when following it clearly hurts usability. `[S1]`
- **CLI-3** Say just enough: show that work is happening, and keep detail for debug output (`-d, --debug`). Silence and floods of output both leave users lost. `[S1]`
- **CLI-4** Treat the CLI as a conversation: make features easy to discover, suggest corrections and next steps, and show intermediate state in multi-step work. `[S1]`
- **CLI-5** Write output and errors as if you are on the user's side and want them to succeed. `[S1]`

## Basics

Core rules: CORE-2, CORE-3.

- **CLI-6** Use a maintained argument parser, including a language's built-in parser, when the command has options or nontrivial argument syntax. Keep parser behavior, help, and validation consistent. A fixed invocation with no argument grammar needs no extra library. `[S1]`
- **CLI-7** Choose safe defaults for settings that can be inferred. Explain required credentials or product setup rather than silently choosing an account or pretending all tools can work without setup. `[S1,S2]`

## Help

Core rules: CORE-4.

- **CLI-8** When a command needs args and gets none, show concise help: a description, one or two examples, key flags, and a pointer to `--help`. Skip this for a command that is interactive by default. `[S1]`
- **CLI-9** For git-like tools, also show help for `app help` and `app help sub`. `[S1,S2]`
- **CLI-10** Lead help with examples of common and complex uses, and list the most common flags and commands first. Move long example lists to a cheat sheet or web docs. `[S1]`
- **CLI-11** Consider building examples as a series from simple to complex uses. Show the actual output when it helps and is short. `[S1]`
- **CLI-12** Use formatting in help, such as bold headings, so it is easy to scan. `[S1]`
- **CLI-13** Make help formatting terminal-independent, with no escape codes when piped, and keep its structure regular. Agents and scripts can then parse it. `[S1,S2]`
- **CLI-14** Include a documentation and support route in help, appropriate to the tool: installed docs, a repository, a maintainer contact, a website, or an issue tracker. When web docs exist, link directly to the relevant page or subcommand anchor. Local documentation is sufficient where CLI-20 permits it. `[S1]`
- **CLI-15** When input is wrong, suggest the likely intended command, for example `brew upgrade jq` for `brew update jq`. You may offer to run it, but only on a TTY. `[S1]`
- **CLI-16** Avoid running a guessed correction silently, most of all when it changes state. If the tool accepts the mistyped form, support and document that form long term. `[S1]`
- **CLI-17** When a command expects piped input but stdin is a TTY, show help or a notice instead of appearing hung. A documented mode that intentionally reads terminal input may wait for it. `[S1]`
- **CLI-18** Write help as if for a new teammate: state input formats, special terms, and how resources relate. Agents load help text into their context. `[S3]`
- **CLI-19** List the tool's own env vars in an "Environment" section of `--help`. `[S4]`

## Documentation

- **CLI-20** For publicly distributed tools, provide searchable web docs. Internal or small tools may keep their complete documentation with the installation or repository. `[S1]`
- **CLI-21** Provide terminal docs that match the installed version, and let the tool show them (for example `app help <topic>`). Consider man pages as well. `[S1]`
- **CLI-22** When a mutation has a dry run, pair its documented example with the dry-run form. `[S2]`

## Output

Core rules: CORE-6, CORE-12.

- **CLI-23** Check separately whether stdout and stderr are TTYs, and use each result to choose color and layout for that stream. Animations follow CLI-31. `[S1]`
- **CLI-24** Offer --plain with a documented record/field format when human tables or wrapping would break line tools. Specify escaping for embedded delimiters and newlines. A suitable stable native text format needs no duplicate mode. `[S1]`
- **CLI-25** Consider --format for genuinely distinct formats, such as table, json, and ndjson. Keep --json as an alias for the JSON result mode when offered. Use an explicitly framed stream format for ongoing records; a finite JSON document and an NDJSON stream are different contracts. `[S2]`
- **CLI-26** Print useful human success feedback and say what changed. Offer -q, --quiet to suppress nonessential human feedback. Preserve the promised machine result and required error behavior; define any mode that intentionally suppresses results. `[S1]`
- **CLI-27** Make current state easy to see, for example with a status command for resources the tool owns, and suggest commands to run next. Agents check results with follow-up commands, not only exit codes. `[S1,S4]`
- **CLI-28** Make non-obvious actions outside the command's stated purpose visible: external files or remote services, for example. Internal caches need not produce routine notices. Escape terminal control characters in untrusted display fields; an explicit raw payload mode may preserve bytes without treating them as presentation. `[S1]`
- **CLI-29** Consider compact, scannable formats (like the `ls` permission string), and symbols or emoji where they add clarity without clutter. `[S1]`
- **CLI-30** Use color with intention and sparingly (for example red for errors), and do not rely on color alone for meaning. Agents cannot read color. `[S1,S4]`
- **CLI-31** Show animations only on their actual terminal destination, normally stderr, with suitable terminal capabilities and human feedback enabled. Redirected diagnostics remain plain. Color overrides never enable animation. `[S1]`
- **CLI-32** Show developer-only details only in debug output (`-d, --debug`), and print stderr messages without log-level labels (`ERR`, `WARN`) by default. `[S1]`
- **CLI-33** Automatically page only human output whose destination is a TTY, with a usable terminal control channel and interaction enabled. Honor PAGER; less -FIRX is a default when available. Never auto-page machine output or redirected results. An explicit pager request needs its own documented channel contract. `[S1]`
- **CLI-34** Show only high-signal fields in default human output, and keep low-level fields (raw UUIDs, MIME types) for `--json` or a detailed mode. Agents that need fewer tokens use the controls in CLI-35. `[S3]`
- **CLI-35** Keep output format separate from human feedback: --json and --plain select formats, -q suppresses routine feedback, and -d requests diagnostics. Consider declared field/detail selectors for large machine results. Quiet/debug must not silently change a promised machine schema. `[S1,S3]`
- **CLI-36** Offer search, filter, and limit options (for example `--limit`) on commands that can return many records. Agents pay for every line in tokens and time. `[S3,S4]`
- **CLI-37** Say when output is cut, and say how to get the rest or narrow the query. `[S3]`
- **CLI-38** Consider a default size cap on list and search commands only, and send complete output everywhere else. S3 caps all responses, and this skill narrows that to list and search. `[S3]`

## Output contract

Core rules: CORE-7.

- **CLI-39** Version structured result contracts, in an envelope or a documented format/version selection that preserves native payload shapes. Define compatible major versions and require consumers within a supported major to tolerate unknown optional fields. Adding fields is safe only within that reader contract; test against an older consumer. `[S2,S4]`
- **CLI-40** Publish schemas and examples for structured results and errors, including framing, optional fields, nesting, and unknown-field compatibility. For artifacts and existing protocols, name their native format contract instead of inventing a result schema. `[S2,S4]`
- **CLI-41** Treat a move of any output to another stream as a breaking change (CLI-93). Consumers redirect stdout and stderr separately. `[S4]`
- **CLI-42** Use stable identifiers in structured output, and show a readable name next to each ID. Prefer type-prefixed IDs such as `msg_01HXYZ`. `[S2,S3]`
- **CLI-43** Reject incompatible schema or state versions clearly. Define which major versions and required capabilities are supported; an unfamiliar compatible minor version or optional field is not automatically an error. `[S2,S4]`

## Errors and exit codes

Core rules: CORE-3, CORE-11.

- **CLI-44** Keep error output high signal. Consider grouping repeated errors of one type under one explanatory header. `[S1]`
- **CLI-45** Put the most important information at the end of human error output. Users look there first. `[S1]`
- **CLI-46** For finite CLI --json results (including an equivalent --format=json), stdout carries the documented result and stderr is empty on success or contains one final JSON error object with stable code, message, and documented optional details on failure. Aggregate multiple failures in that envelope. Disable automatic prompts. Missing required input or confirmation returns a JSON error naming its noninteractive input path or the appropriate --force/--confirm flag, never implicit consent. Interaction requires an explicitly selected separate terminal channel, with --no-input unset, and must keep UI bytes off stdout and stderr. Suppress human progress, warnings, signal notices, and raw debug/stack text on these streams; put needed diagnostics in declared fields or an explicitly enabled log. Streaming and native protocols define their own complete result/error framing. Test terminal and redirected confirmation paths and partial-output failures. `[S1,S2]`
- **CLI-47** For unexpected failures, return the normal machine error envelope or a concise human bug-report message. Make redacted stack/details available through explicit debug output or a log. Redact credentials and sensitive payloads across errors, traces, previews, and diagnostic exports, including logs revealed after failure. `[S1]`
- **CLI-48** Make bug reporting easy through the support route in CLI-14, with an inspectable redacted diagnostic bundle where useful. Keep secrets and private payloads out of URL parameters and prefilled reports. `[S1]`
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

Core rules: CORE-5, CORE-13.

- **CLI-51** Prefer flags to positional args. Flags are clearer and easier to extend. `[S1]`
- **CLI-52** Keep args to one kind of thing: one arg, or several of the same kind, as in `rm a b`. Args with different meanings fit only a common primary action, as in `cp <src> <dst>`. `[S1]`
- **CLI-53** Reserve one-letter flags for common flags, most of all at the top level. This keeps short flags free for future flags. `[S1]`
- **CLI-54** Use these standard names: `-a, --all`, `-d, --debug` (debug output), `-f, --force`, `--json`, `-h, --help`, `-n, --dry-run`, `--no-input`, `-o, --output` (output file, never a format), `-p, --port`, `-q, --quiet`, `-u, --user`, `--version`. `[S1]`
- **CLI-55** Give `-v` one clear meaning: use `-d` for debug output and `-v` for version, or leave `-v` unused. `[S1]`
- **CLI-56** Give unambiguous names to flags that have no standard name, for example `--user-id` for an ID. Keep `-u, --user` where it has the standard meaning. `[S3]`
- **CLI-57** Support `-` to read from stdin or write to stdout when input or output is a file. Consider accepting JSON on stdin for structured input. `[S1,S2]`
- **CLI-58** Distinguish an absent flag, an omitted optional value, an explicit empty string, and a reset operation. Prefer unambiguous parser syntax such as --flag=value for optional values. --name= and a quoted empty argument are valid explicit empty values; use a sentinel such as none only when the domain reserves it. `[S1]`
- **CLI-59** Make args, flags, and subcommands order-independent where you can. Users often recall the last command and add a flag at the end. `[S1]`
- **CLI-60** Give each flag one job. A flag that skips confirmation must not also choose the action. `[S2]`
- **CLI-61** Read a secret file inside the tool, through a flag such as `--password-file`. A shell form such as `--password $(< file)` still puts the secret in a flag. `[S1]`

## Interactivity

Core rules: CORE-8, CORE-10.

- **CLI-62** Prompt for missing input only when the product's interaction mode and CORE-8 allow it. Otherwise name the noninteractive input path. A TTY by itself is not a requirement to prompt. `[S1]`
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
- **CLI-72** Expose application operations through CLI commands when the intended script/agent workflows require them, and record any promised parity across interfaces. A product may choose complete CLI parity as a default. Presentation-only focus, scrolling, and layout need no CLI path. A TUI-first product may stage its release according to its users' needs. `[S2]`

## Robustness

- **CLI-73** Validate input early and strictly, and stop with a clear error before anything changes. `[S1,S3]`
- **CLI-74** For interactive human runs with feedback enabled, respond promptly (aim for about 100 ms) and explain work before a potentially slow call. Quiet and machine modes follow their output contracts rather than printing routine notices. Avoid emitting a message for every cheap internal request. `[S1]`
- **CLI-75** Show progress for long work when feedback is enabled: animation only under CLI-31, otherwise bounded plain diagnostics. Machine modes follow CLI-46 or their declared stream protocol. Keep errors visible even when routine feedback is suppressed. `[S1,S4]`
- **CLI-76** Run work in parallel where it helps, and keep parallel output robust and free of interleaving. Use a library for it where you can. `[S1]`
- **CLI-77** When failure hides useful context behind a progress display, restore normal output and expose the relevant redacted diagnostics. Respect the machine-mode framing rather than dumping arbitrary logs. `[S1]`
- **CLI-78** Give network calls a timeout with a sensible default that users can configure. `[S1]`
- **CLI-79** Make retries and interrupted work recoverable where the operation permits it. Document partial completion and unknown outcomes. Avoid replaying non-idempotent effects merely because the previous result was lost. `[S1]`
- **CLI-80** Design for restart after abrupt termination as well as normal cleanup. Bound cleanup and use transactions or atomic replacement where needed for consistency. Deferred cleanup helps graceful exits but cannot run after every crash or forced kill. `[S1]`
- **CLI-81** Expect misuse: wrapper scripts, bad networks, parallel instances, and odd environments such as case-insensitive filesystems. `[S1]`
- **CLI-82** Keep code and special cases simple, and make commands deterministic. Callers can then predict the next step. `[S1,S4]`

## Safe changes

Core rules: CORE-9, CORE-10.

CLI-83 decides when a preview is useful. Once offered, its plan, limits, validation, and tests follow CLI-86 to CLI-89, CLI-92, and CLI-133.

- **CLI-83** Offer -n, --dry-run when a meaningful preview helps validate a risky, complex, or automated mutation. Record whether it is supported and what it can know: observed targets, intended effects, unknown generated values, and remote constraints. Naming scripts as users does not require a fictitious exact preview for every mutation. `[S1,S2,S4]`
- **CLI-84** Match confirmation to the danger level in the table below, and make severe actions hard to confirm by accident. When a severe action asks for a typed name, offer `--confirm="name"` so it stays scriptable. `[S1]`
- **CLI-85** Treat non-obvious data loss as severe, for example a lowered config limit that deletes items. `[S1]`

Danger levels (CLI-84), with clig.dev's examples:

| Level | Example | Confirmation |
|---|---|---|
| Mild | Delete a file | Optional. A command named `delete` may need none. |
| Moderate | Delete a directory or a remote resource, or make a bulk change that is hard to undo | Prompt. Consider a dry run. |
| Severe | Delete a whole remote app or server | Prompt. Consider asking the user to type the resource name. |

- **CLI-86** Share planning and target resolution between preview and execution. In a real run, build one plan, show the relevant intent, confirm when required, then apply that plan. In machine mode, include preview/result information in the documented envelope rather than printing extra documents. Separate invocations observe separate state unless an explicit saved-plan contract says otherwise. `[S2]`
- **CLI-87** Store action mode, destination, scope, stable target identities, and relevant observed versions/preconditions in the plan. Use the resolved values for validation, preview, and application. Where concurrent changes affect safety, apply conditionally or revalidate and reject/reconfirm a changed plan. `[S2]`
- **CLI-88** When confirmation is required, ask after the plan is built and before mutation. A preview alone does not require confirmation for the mutation it does not execute. Keep required validation and authorization checks in the real application path. `[S2]`
- **CLI-89** State that a preview describes intended effects against observed state, not guaranteed future success. It cannot promise remote acceptance, future target state, or unknown generated values. For dangerous changes, define stale-plan rejection or renewed confirmation rather than relying on an old successful preview. `[S2]`
- **CLI-90** Make operations idempotent where possible, for example with idempotency keys or natural deduplication on writes. Agents retry. `[S1,S2,S4]`
- **CLI-91** Offer an early check that validates input without running it, such as a syntax-check mode, before destructive actions. `[S4]`
- **CLI-92** Return an exit code from a dry run for whether its declared validation succeeded. Success is not authorization or a guarantee that a later mutation is safe or will succeed. Report unresolved checks and unknown effects explicitly. `[S4]`

## Future-proofing

- **CLI-93** Deprecate incompatible changes to public commands, input, configuration, or machine output with a documented migration period appropriate to the product. Additive compatible changes do not require deprecation. Weigh the cost to existing scripts and agents. `[S1,S4]`
- **CLI-94** Keep breaking changes rare, even with semantic versioning. A major version bump every month makes the version number meaningless. `[S1]`
- **CLI-95** Keep changes additive, for example add a new flag in place of changing an old one, as long as the interface does not bloat. `[S1,S4]`
- **CLI-96** Before a non-additive change, warn inside the program and say how to migrate (ship a migration path when you can). Stop the warning once usage has changed. `[S1,S4]`
- **CLI-97** Require full subcommand names, and keep aliases explicit and stable. A catch-all subcommand or prefix matching blocks new commands later. `[S1]`
- **CLI-98** Keep startup, help, and promised local/offline capabilities usable without optional services. Remote operations may require their product service; report that dependency and failures clearly. Never block essential behavior on analytics or optional update checks. `[S1]`
- **CLI-99** Define the relevant input/output, error, and compatibility contract before implementation. For mutations, decide preview support under CLI-83, confirmation under CORE-9, and stale-target behavior under CLI-87. Native payload formats need no replacement JSON schema. `[S2]`
- **CLI-100** Version application-owned persistent schemas and migrate older state when supported. Preserve native or externally owned file formats rather than adding arbitrary version fields to artifacts. Consider tracking state lineage so stale local state does not overwrite newer authoritative state. `[S4]`

## Signals

- **CLI-101** On Ctrl-C, stop or cancel work promptly and begin bounded cleanup. Give immediate human feedback when enabled, but respect machine error framing and active TUI ownership of the terminal. Define interrupt exit behavior. `[S1]`
- **CLI-102** Bound cleanup and make a second Ctrl-C terminate promptly without blocking on diagnostic I/O. Explain that behavior before or during the first interrupt when the output mode permits it. `[S1]`
- **CLI-103** Handle SIGTERM with cleanup that leaves state consistent. `[S4]`

## Configuration

- **CLI-104** Use flags for per-run choices and declared env/config settings for persistent preferences. Keep confirmation bypasses and one-use authorization out of persistent defaults. Choose a config file when it adds useful structure. `[S1]`
- **CLI-105** Keep project settings in a tool-specific file when the product has project scope. Define which fields untrusted projects may control; credential routing, executable hooks, and remote endpoints need a deliberate trust boundary. `[S1]`
- **CLI-106** On Unix, prefer XDG locations for new tools; preserve established platform conventions and existing contracts when required. On other platforms, use native config locations. Document path precedence and fallbacks. `[S1]`
- **CLI-107** Ask before you change config that belongs to another program, and say exactly what you change. Prefer a new file over appending, and mark edits to shared files with a dated comment. `[S1]`
- **CLI-108** For declared configuration sources, apply this default precedence, highest first: explicit flags, process env, trusted project config, user config, system config, defaults. Only load sources the tool supports. Do not let a project file silently become arbitrary process environment. `[S1,S4]`

## Environment variables

Core rules: CORE-13.

- **CLI-109** Use env vars for behavior that depends on where the command runs, such as a profile set once for a whole session. `[S1,S4]`
- **CLI-110** Name own env vars with uppercase letters, digits, and underscores, starting with a letter or underscore and prefixed with the tool name. Document their parsing, empty-value meaning, and precedence. `[S1,S4]`
- **CLI-111** Keep env var values on a single line. Multi-line values cause problems with the `env` command. `[S1]`
- **CLI-112** Leave widely used names, such as POSIX standard vars, to their existing meaning. `[S1]`
- **CLI-113** Honor common env vars relevant to the capabilities the tool actually implements: color controls (CORE-12), EDITOR/PAGER for opted-in interaction, supported proxy vars for network calls, and platform terminal/path vars. Do not promise unsupported variables or import unrelated process behavior. `[S1]`
- **CLI-114** Consider per-directory .env support for declared project settings. Parse it as data, allow only documented fields, and apply the project trust boundary (CLI-105). A directory file must not silently choose executable helpers, credentials, or endpoints outside that boundary. `[S1]`

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

- **CLI-125** When agents/scripts are supported consumers, let them discover commands, inputs, and output shapes through installed help/docs. Consider --schema or a manifest command for structured discovery. `[S2]`
- **CLI-126** When agent use is a supported workflow, ship concise installed agent-facing usage examples. A small existing help interface may provide the needed discovery without a separate skill. `[S2]`
- **CLI-127** Consider marking commands that destroy data or reach outside systems, in help and in any schema, so agents see the risk. `[S3]`
- **CLI-128** Consider MCP when a concrete client needs it. Derive its schemas from shared operations where practical and keep regression tests. Whether CLI or protocol is the primary surface follows product needs; share application rules and trusted authorization. `[S2,S4]`

## Testing

CLI-129 to CLI-134 test applicable public contracts. CLI-135 to CLI-140 apply when agent usability is a supported product goal; scale evaluations to the change.

- **CLI-129** Test the contract early with a second consumer, such as a shell one-liner through `jq` or a small agent skill. If the output reads badly there, fix the schema. `[S2]`
- **CLI-130** When integrations are part of the product, test against controlled real-system fixtures where available and check fake/real contract parity. Isolate mutations and credentials. Missing access is unverified coverage, not a reason to use live user state. `[S2]`
- **CLI-131** Test promised CLI features through the public CLI. Test TUI-only presentation or other protocol surfaces at their own public boundaries; missing a CLI path is a gap only when parity was promised. `[S2]`
- **CLI-132** Keep fault injection inside the product boundary (app network seam, proxy, container), with isolated scope and postcondition checks. Never change host machine state. `[S2]`
- **CLI-133** Under fixed input/state fixtures, check that preview selection and intended effects match what execution attempts. Separately test intervening target changes, authorization failures, partial effects, and unknown outcomes where applicable. Generated or remote-dependent values follow the declared preview limits. `[S2]`
- **CLI-134** Keep regression tests (for example with bats-core) for escape hatches and output formats, and validate output against its schema in CI. `[S4]`
- **CLI-135** Prototype the commands, use them yourself, and collect user feedback on real use cases. `[S3]`
- **CLI-136** Evaluate supported agent workflows with realistic multi-step tasks and verifiable outcomes. Use the expected normal interaction loop. Request a short action rationale only when it serves the evaluation; measure observable calls and outcomes without requiring private deliberation. `[S3]`
- **CLI-137** Make verifiers accept any correct answer, whatever its formatting or strategy. Consider listing the commands you expect agents to call. `[S3]`
- **CLI-138** Record metrics beyond accuracy (runtime, call count, tokens, errors), and use call patterns to find commands to merge. `[S3]`
- **CLI-139** Read raw transcripts and agent feedback, including what agents leave out. Many redundant calls suggest new limits or page sizes, and many invalid-argument errors suggest clearer help. `[S3]`
- **CLI-140** When agent usability is a product goal, evaluate help/naming changes and confirm gains on held-out tasks. Consider using transcripts to identify improvements, while keeping evaluation prompts and budgets comparable. `[S3]`

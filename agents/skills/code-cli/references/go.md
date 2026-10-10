# Go rules

Use this reference for Go implementations. Cobra, koanf, and the Charm libraries are optional recipes, not reasons to migrate an existing stack. Apply the contracts selected in SKILL.md, arch.md, cli.md, and tui.md. A mapping line gives one implementation choice, not an extra requirement.

## Evidence and applicability

Verify error propagation, numeric conversion, panic rendering, and forced signal exit against the application's own dependencies. Library observations here are verification targets, not claims that every current version was tested. Use `go doc` and the selected module's source for exact APIs. Pin dependency versions in the application's go.mod/go.sum and derive the Go minimum from those versions, rather than from this reference.

Terms:

- **App value**: per-run flags, configuration, writers, and runtime dependencies. It does not capture errors in a side channel.
- **`run` function**: the function called by main that owns cleanup, rendering, and the exit code.
- **Usage error**: invalid invocation syntax or inputs. Runtime failures have a different error type or classification.
- **Machine mode**: the finite `--json` contract selected in CORE-6. Protocol traffic, completion scripts, exported artifacts, and native streams retain their declared formats.

Build order: select the applicable contract, implement domain rules and application services, implement parsing and output, then verify the built binary in an isolated harness. Add configuration, prompts, signals, a daemon, or a TUI only when the product needs them.

## Project setup and layout

- CLI-118: A module with a main package in `cmd/<name>` supports `go install <module>/cmd/<name>@<version>`. Preserve an existing suitable layout.
- ARCH-8, ARCH-9: Separate the pure domain rules, effectful application services, and adapters. A store interface belongs with the service that consumes it, not necessarily inside the pure core.

- **GO-1** When selecting Charm libraries, choose compatible major lines and check module paths and dependency requirements. Preserve a working older stack unless migration is justified. Different major versions can coexist legally but have distinct Go types. Verify with `go list -m all` and compilation. `[S15]`
- **GO-2** Consider a command-tree constructor taking the app value so tests and repeated runs receive fresh flags and state. `[S12]`
- **GO-3** Review generated scaffolding for the selected contract: config paths, stdout notices, exit mapping, and process exits. Generated defaults are not product decisions. `[S12]`

## Architecture

- **GO-4** Define small interfaces in consuming packages and return concrete implementations. Put I/O orchestration in application services around a pure core. Introduce interfaces for a real boundary, not merely to duplicate a concrete type for mocking (ARCH-8). `[S16]`
- **GO-5** Where package boundaries matter, consider a `go list -deps` check prohibiting CLI and terminal dependencies in the pure core. `internal/` controls external import access, not layering inside the application (ARCH-76). `[S16]`

## Execution, errors, and output

- **GO-6** Let main call `os.Exit(run(os.Args[1:]))`. Own cleanup and error mapping inside `run`; return errors below that boundary. Fatal logging and exit helpers bypass deferred cleanup and centralized rendering (CLI-49, CLI-80). `[S13,S15,S16,S17]`
- **GO-7** Recover unexpected panics at the process boundary and in owned goroutines, release resources, and classify them as internal failures. In finite JSON mode, emit one final JSON error object on stderr, never a raw stack. Human mode prints a concise bug-report hint. Send detailed stacks only through explicitly requested, redacted debug output, a documented structured field, or a selected debug file. A goroutine must forward its failure to its owner; recovering only in `run` does not catch another goroutine's panic. `[S16]`

Choose one final error renderer implementing CLI-46, including its stream contract and delivery limits. Assemble finite results before emitting them where practical. Check encoder and writer errors. Logger prefixes, warnings, and library debug output must follow the same contract.

Establish the requested mode before fallible setup, including config loading, and preserve that mode on parse errors. Use the registered option grammar to identify mode flags, including value consumption, explicit booleans, shorthand, and `--`; a token-equality scan is not a parser. If a mode cannot be resolved because its own syntax is invalid, report that syntax error using the documented default format. Test ordering and malformed-input cases for the chosen parser.

- CORE-6, CORE-7: Tag JSON fields and test the declared schema, including errors. Native protocol and artifact output needs its own contract rather than a JSON wrapper.
- ARCH-11: Check stdout writes and encoding errors. A closed pipe or full disk is an output failure.

- **GO-14** Emit machine records and plain formats without styling. Use encoders and direct writers that preserve required bytes, including tabs. Human renderers may normalize whitespace or add terminal control sequences. `[S15]`
- **GO-15** Where the JSON schema requires an empty list, initialize slices so the encoder emits `[]`, not `null`, and test it. `[S16]`
- **GO-16** Map sentinel and typed errors to documented exit codes at one boundary. Avoid matching message strings. Account for the parser's actual error API: Cobra returns several untyped errors, so wrapping only flag parsing is insufficient. `[S12,S13]`
- **GO-17** For Cobra, distinguish usage validation from effectful callbacks explicitly. Return usage errors from argument and flag-rule validators. Wrap errors from effectful pre-run, run, and post-run callbacks as runtime/domain errors before they reach the boundary; remaining known Cobra dispatch/validation errors can then map to usage errors. Keep the phase assumption documented and tested. Alternatively use a parser with typed usage errors. Validate required flags/groups before fallible setup when early rejection matters. Test unknown commands, unknown subcommands, required flags, flag groups, malformed values, extra args, and built-in commands. `[S12,S13]`
- **GO-18** With Cobra, set `SilenceErrors` and `SilenceUsage`, use `ExecuteContext`, and render the returned error once. Optional fang styling is suitable only after its help/error paths pass the same output and terminal tests. A no-op fang error renderer alone does not prove that terminal queries or other writes disappear. `[S13]`
- **GO-19** Return callback errors normally so execution stops. Built-in help/version rendering can bypass application callbacks, discard write errors, or write again after an output failure. Test the selected version against a failing writer and adapt those paths to preserve output errors and stop writes to a failed stream. Non-error callbacks may also print diagnostics without returning failure. Completion callbacks own their dependency failures and follow their shell protocol. `[S12]`

A practical Cobra adapter wraps each effectful callback at construction, preserving the error:

```go
func runtimeCallback(f func(*cobra.Command, []string) error) func(*cobra.Command, []string) error {
    return func(c *cobra.Command, args []string) error {
        if err := f(c, args); err != nil {
            return runtimeError{err} // Unwrap preserves domain error classification
        }
        return nil
    }
}
```

This wrapper does not turn errors into success and does not require traversing a finished tree to install guards. Built-in completion is a protocol, not an ordinary finite JSON command. Test `help bogus`, bare `__complete`, and completion dependency failures separately. Do not rely on a root setup hook to secure completion callbacks.

## Commands, flags, and help

- CLI-8: Choose the bare-root behavior and missing-argument help according to the product. Use concise usage errors with a useful example and help pointer.
- CLI-21: Help, version, completion, and man-page output have distinct native formats. Add only the interfaces the product supports and validate their actual behavior.

- **GO-8** Give each public command an appropriate args validator. Cobra's permissive default can silently accept extra arguments. Group commands need explicit unknown-child behavior too. `[S12]`
- **GO-9** Let a successfully parsed help option bypass domain validation, configuration, and application work. Malformed option syntax remains a usage error. Use the same registered flag grammar as execution: `--name -h` consumes `-h` as a value, `--help=false` is false, and options after `--` are arguments. Do not implement help precedence with a raw token scan. Check these cases and shorthand forms against the selected parser. `[S12]`
- **GO-10** If using fang or another help renderer, verify that each value-taking flag displays its value syntax in piped and terminal help. Add a usage annotation or choose another renderer when needed. `[S13]`
- **GO-11** Verify help through a pipe and on a silent pseudo-TTY: readable layout, no unwanted padding or escapes, and bounded latency. With plain Cobra, configure version/help and verify their error paths under GO-19. If fang replaces help during execution, changing Cobra's help function beforehand may not affect its output. `[S13]`
- **GO-12** Keep shared setup explicit. Cobra's nearest persistent hook can hide an ancestor hook unless traversal is configured; test the selected setting. Skip config and credentials for commands that do not need them. Use deferred cleanup rather than post-run hooks, which may not run after failure. `[S12]`
- **GO-13** Keep completion fast, side-effect free, and limited to the shell's completion protocol on stdout. Disable filename fallback when inappropriate. Verify filtering on every supported shell; extension directives may not have portable semantics. `[S12]`

## Config

Configuration is optional. Select its scopes and trust boundaries first. For koanf, layer order, env transforms, flag providers, and decoding all need application tests; their defaults do not define the product contract.

- **GO-20** Load only selected configuration layers from lowest to highest precedence. Define whether an explicit file replaces default file discovery. Project configuration must have a deliberate trust scope (CLI-108). `[S14]`
- **GO-21** If flags override configuration, load changed flags last and ensure an unset flag preserves lower-layer values. Keep per-run authorization controls such as `--force` out of persistent configuration. Test the chosen koanf flag provider with an existing lower-layer value. `[S12,S14]`
- **GO-22** Map allowed environment names explicitly to config keys and convert their values using the schema before merging. Define empty values and list delimiters per setting. Keep secrets on the selected protected input channels. Converting all merged strings can silently permit file types the file schema rejects. `[S14]`
- **GO-23** Implement the selected path policy. If using XDG paths on Unix, use an absolute XDG_CONFIG_HOME first; require HOME only for the `$HOME/.config` fallback. Go's `os.UserConfigDir` follows platform conventions and returns an error when its required environment value is absent. A hand-built join against an empty HOME is what can produce a relative path. Skip only a missing optional default file, not permission or parse errors. `[S14,S16]`

Preserve source information before numeric conversion. For strict integer settings in JSON config, use a parser that retains numeric tokens, such as `encoding/json.Decoder.UseNumber`, then convert `json.Number` according to the field schema. Check the selected koanf parser: decoding into `map[string]any` with ordinary `json.Unmarshal` converts numbers to float64, loses the distinction between `1` and `1.0`, and can round large integers. A later numeric hook cannot recover that information.

Decode only after checking source types and numeric ranges. A mapstructure decoder with `ErrorUnused: true` and weak typing disabled still needs numeric checks before coercion. Under a strict integer policy, accept integer source types or preserved integer tokens, require the target bit width, and reject file strings and decimal/exponent syntax such as `1.0` or `1e0`. Convert preserved integer tokens and environment strings with `strconv.ParseInt`/`ParseUint` using the target width before merging. If a product allows integral floats, test integrality, finiteness, and target range before conversion. Test `1`, `1.0`, `"1"`, integers above 2^53, and target-width boundaries through the actual file parser and decoder. Validate domain constraints after decoding. Unknown keys must fail with their key names.

## Interactivity and prompts

- CLI-63: For echo-free secret input, save terminal state, arrange cancellation and restoration, then start reading. Noninteractive secret input can use a protected file descriptor or secret store; it need not be an argv value.

- **GO-24** Before opening a prompt, apply the selected interaction policy yourself. `--no-input` forbids all interaction, even if a library can reopen `/dev/tty`. Finite JSON mode disables automatic prompts and permits only the explicit separate-terminal interaction in CLI-46. For the ordinary prompt mode require usable input and output terminal endpoints; return actionable failure when required input is missing. Explicit separate-terminal mode may use an agreed terminal while data remains redirected. `[S15]`
- **GO-25** Route prompts to the chosen terminal, normally stderr for ordinary CLI prompting. Provide line/accessibility mode where supported. Verify Ctrl-C and SIGTERM for both modes. If a library's line reader ignores context, returning from a `select` does not stop its reader goroutine: use a cancellable reader with owned lifecycle, join it during cleanup, or select another prompt implementation. Do not leave a reader consuming input after a reusable `run` returns. `[S15]`

## Color and styling

- **GO-26** Test actual output bytes against CORE-12 rather than only a color-profile enum. Check color separately from non-color attributes, and ensure plain/no-style rendering adds neither attributes nor reset codes. Preserve bytes belonging to a native payload rather than stripping it as presentation. `[S15]`
- **GO-27** Compute CORE-12's per-stream color and styling decisions before constructing renderers. Adapt library-specific environment interpretation locally instead of assuming it matches that policy. Avoid mutating process-global environment in reusable or parallel code. `[S15]`
- **GO-28** Keep debug logging separate from result rendering. In finite JSON mode suppress human stderr logs, or send debug information to an explicitly chosen file or documented structured field. Verify library logger prefixes and timestamps. `[S15]`
- **GO-29** Query a terminal background only when the choice is necessary and the query is bounded. Prefer palettes that work on light and dark backgrounds. Verify startup on a silent terminal and Windows escape processing on supported Windows consoles. `[S15]`

## Signals, context, and cleanup

- CLI-80: Verify the destination platform/filesystem's rename and durability guarantees before promising atomic replacement. A temporary file and rename do not alone guarantee crash durability.

- **GO-30** Pass request context to I/O and waits. Use a separately bounded cleanup context only when cleanup must outlive request cancellation. `[S16]`
- **GO-31** Where Unix signals are supported, handle SIGINT and SIGTERM at the process boundary, preserve the signal cause, clean up, and map to the documented status (commonly 130 and 143). Windows console events have different guarantees and need platform tests. `[S13,S16]`
- **GO-32** The first signal cancels work. Keep an emergency signal handler independent of cleanup so a second signal immediately calls `os.Exit` with the documented status, without I/O or locks. Restoring signal handling is an alternative only when verified to restore termination: `signal.Stop`, `signal.Reset`, and a `NotifyContext` stop function can restore an inherited ignored or blocked disposition. Print any explanation before a possible blocked cleanup path, subject to the output contract. Test normal and inherited-ignored SIGINT startup, full undrained stderr, and stalled cleanup within a bounded subprocess lifetime. `[S16]`
- **GO-33** On Unix, if mapping broken pipes to an application exit status, catch SIGPIPE and check EPIPE rather than globally ignoring SIGPIPE. Ignored signals can be inherited by children. Stop writing on EPIPE and test both parent and child pipelines. Keep platform-specific handlers behind build constraints and release signal registrations when a reusable run returns. `[S16]`

Define signal registration ownership, avoid concurrent handlers across runs, and distinguish signal cancellation from an unrelated context deadline.

## TUI

Use these rules only for an applicable Go TUI. Keep runtime dependencies (context, clients, cancellation handles) separate from replayable model state, even when the framework stores both in one Go wrapper. Commands may be opaque closures; compare explicit effect descriptors or observed effects rather than closures.

- **GO-34** Apply the selected terminal policy before starting Bubble Tea. Ordinary full-screen mode requires appropriate terminal endpoints. An explicit separate-terminal mode may coexist with redirected result data. `--no-input` must prevent library fallback to a terminal device. Test the actual input and renderer destinations. `[S15]`
- **GO-35** Preserve the framework's terminal restoration on panic and cancellation within TUI-6's exit guarantees, then map its error through the CLI renderer. Check the selected version's recovery scope, signal handling, and panic output. Adapt recovery to GO-7 in every supported mode while preserving cleanup. Excluding a TUI path from JSON does not relax human-mode diagnostics. Recover owned goroutines separately and forward failures to the program. Bind raw-mode Ctrl-C to the policy selected under TUI-8. Verify TUI-6 with a second keyboard Ctrl-C while output cleanup is stalled, including after ordinary input handling stops. An external SIGINT test alone does not check this path. Test init, update, view, command, and owned-goroutine failure paths. `[S15]`

For the selected Bubble Tea version, verify initial size behavior, view-declared terminal modes, bracketed paste, key disambiguation, context cancellation, and SIGTERM's returned error. Neither a startup size message nor a particular panic wrapper is an unversioned guarantee.

## Testing

- **GO-36** Test the built binary through pipes and, where relevant, a pseudo-TTY: streams, exact exits, option boundaries, configuration errors, color precedence, prompts, signals, and terminal restoration. Bound the entire child lifetime, register kill-and-wait cleanup immediately after starting it, and drain both output streams. Check errors from terminal-state capture before comparing states. A prompt-read deadline alone does not bound `Wait`. Keep a checked terminal endpoint alive for the before/after comparison. Verify platform support instead of assuming a Unix PTY test covers Windows. `[S16,S17]`
- **GO-37** Construct an isolated child environment with temporary HOME/config/cache directories and explicit PATH, TERM, and required platform variables. Retain documented platform necessities rather than assuming an empty environment always boots. Set child env rather than global test-process env when tests run concurrently. `[S16,S17]`
- **GO-38** Assert exact exit codes. In testscript, `! exec` checks failure, not a particular code; use a checked helper or ordinary subprocess tests for the code map. Test process-start failures separately from an exit status. `[S17]`
- **GO-39** Snapshot either final model View output or an emulated terminal's final screen. Stripping escapes from a raw capture does not reconstruct cursor motion or erased content. Normalize only after establishing the rendering boundary. `[S15]`
- **GO-40** Fuzz deterministic parsing and validation with bounded time. Preserve useful failing inputs under `testdata/fuzz`. Use isolated integration tests for process, terminal, and network behavior. `[S16]`

A PTY test's lifetime pattern should be equivalent to this, with every error checked by the product test:

```go
ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
defer cancel()
cmd := exec.CommandContext(ctx, bin, "interactive-command")
cmd.WaitDelay = time.Second
// Attach the PTY, capture and check its initial state, then start cmd.
// Immediately arrange cleanup to kill a live child and wait exactly once.
// Read the prompt with a bound, send Ctrl-C, then await completion with a bound.
// A context deadline is a test failure, not the expected signal exit.
// Capture and check final terminal state through the retained valid endpoint.
```

Add product tests using the supported platform's PTY facilities, with the lifecycle above and any descendants included in cleanup.

## Tooling and release

- **GO-41** Keep dependency metadata tidy and run build, vet, and meaningful tests. Run race checks on supported targets with the required toolchain/cgo setup. Select linters for actual contracts and explicitly handle output/cleanup errors. Verify the application's own dependencies and supported platform builds. `[S16,S19]`
- **GO-42** Run govulncheck on the application's packages before release and on an appropriate CI schedule. Investigate reachability and block on applicable vulnerabilities. Prefer a targeted fixed-version upgrade over updating every dependency without review. `[S16]`
- **GO-43** Derive version output from a release-stamped version, else build info, else a clear development label with revision/dirty state when available. Test the built release artifact; linker symbol names must match release configuration. GoReleaser is an optional release tool. Verify runtime files, OS capabilities, cgo linkage, and installation behavior before claiming a standalone binary. `[S13,S16,S18]`
- **GO-44** Follow Go's module versioning rules, including `/vN` suffixes for module major versions from v2 onward where required. Version the CLI's public behavior separately according to CLI-93 and CLI-94. `[S16]`

When relevant, verify Windows console/ConPTY and named pipes, shell job-control re-raising, Charm or koanf integration, platform durability, and release signing, packaging, and uninstall behavior. Record missing checks as unverified rather than treating this reference as evidence.

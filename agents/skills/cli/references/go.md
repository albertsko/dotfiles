# Go rules: REF-287 to REF-330

This file explains how to build a CLI in Go, from layout to release, with Cobra, fang, koanf, and the Charm libraries. It maps existing REFs to Go, and defines REF-287 to REF-330: library defaults that break a REF, and the Go patterns and tooling the REFs need.

## Terms

The terms in SKILL.md, architecture.md, and tui.md apply. In this file, "command" means a CLI command, and the Command of tui.md is a "TUI command". New terms:

- **Major line**: all releases of a library with one major version, for example v2.
- **Root command**: the top command of the Cobra tree.
- **App value**: one value with the per-run state of the CLI layer: flags, config, writers, logger, and the first error.
- **`run` function**: the function that main calls. It does all the work and returns the exit code.
- **Callback**: a function that Cobra calls during a run: a hook, an args validator, the flag error function, or a run handler (the function that does the command's work).
- **Guard**: a wrapper around a callback. It records the callback's error on the app value, returns nil, and skips the callback once an error is recorded.
- **Prescan**: a loop over the raw args, before Cobra parses them, that finds flags which must act early (`-h`, `--help`, `--json`, `--no-color`). It stops at `--`, so `todo add -- -h` adds an item.
- **Color-aware writer** (short: writer): a wrapper around one output stream that strips or downsamples ANSI codes to match it.
- **CLI error**: one error type with the exit code, a stable kind for `--json` (REF-59), the message, and a fix hint.
- **As checked**: library behavior seen in the versions checked for this file. A release may change it, so each case names a check. Run that check on the CLI's versions, or mark the finding unverified.

## How to use this file

- A mapping line (`- REF-n: ...`) gives one Go way to meet an existing REF. Judge the REF, not the line. A REF with no mapping line needs no Go-specific handling.
- Look up exact APIs with `go doc <package>.<Symbol>`. Examples show one way for a small `todo` CLI, compiled against the versions checked. In them, `a` is the app value.
- "Unix" marks a statement that holds on Linux and macOS only.

Stack, by module path. `go get <path>@latest` stays on the major line of the path:

- Go 1.26 or later, as checked: Bubble Tea, `x/term`, and `x/sys` declare `go 1.26.0`. Set that minimum as the go directive (`go mod edit -go=1.26.0`), not your local patch release. Check: `go list -m -f '{{if and .GoVersion (not .Main)}}{{.GoVersion}} {{.Path}}{{end}}' all | sort -V | tail -3`.
- Commands: `github.com/spf13/cobra`, `charm.land/fang/v2` for styled help and `--version`, and `github.com/muesli/mango-cobra` with `github.com/muesli/roff` for the man page.
- Config: `github.com/knadh/koanf/v2`, with `providers/file`, `providers/env/v2`, `providers/posflag`, `providers/confmap`, and `parsers/toml/v2` under `github.com/knadh/koanf/`, and `github.com/go-viper/mapstructure/v2` for a strict decode. The v1 env provider has another API.
- Terminal: `charm.land/<name>/v2` for bubbletea, bubbles, lipgloss, huh, log, and glamour, `github.com/charmbracelet/colorprofile`, and `golang.org/x/term`.
- Tests: `github.com/rogpeppe/go-internal/testscript`, `github.com/creack/pty` (Unix), and `github.com/charmbracelet/x/exp/teatest/v2`.

Build order. Each step is done when its check passes:

1. Module and layout (REF-287 to REF-289): `go build ./...` and `go vet ./...` pass.
2. Domain core and adapters (REF-290, REF-291): unit tests pass.
3. `run`, the command tree, output, and errors (REF-292 to REF-305): through a pipe, help exits 0, and a bad flag, an extra arg, and an unknown command or subcommand (also under `completion`) exit 2.
4. Config, prompts, color, and signals (REF-306 to REF-319): the checks in their notes pass.
5. The TUI, if planned (REF-320, REF-321): the checks in its notes pass.
6. Tests, CI, and release (REF-322 to REF-330): the black-box tests pass against the built binary.

## Project setup and layout

- REF-131: Ship one module with one main package per binary. Users install with `go install <module>/cmd/<name>@<version>`.
- REF-161, REF-162: Use `cmd/<name>/` for main and the thin CLI layer, `internal/<domain>/` for the domain core (types, rules, and sentinel and typed errors), and one `internal/` package per adapter.

- **REF-287** Import every Charm library that has a v2 line from that line's module path. Mixed lines load two copies of a library with different types, so code fails to compile or behaves differently. `[S15]`
- **REF-288** Consider building the command tree in a constructor that takes the app value, in place of package-level commands and `init()` registration. Each test and script run then gets fresh flags and state. `[S12]`
- **REF-289** Review code from the Cobra generator or user guide. As checked, both read a home dotfile (REF-119) and exit 1 for every error (REF-62), and the guide prints a config notice to stdout (REF-2). `[S12]`

Notes:

- REF-287, as checked: Bubble Tea, Bubbles, Lip Gloss, huh, log, fang, and Glamour have v2 lines under `charm.land`. Their GitHub paths give v1. Helper modules (colorprofile, `x/...`) stay on GitHub. Check: `go list -m all | grep -E '^github.com/charmbracelet/(bubbletea|bubbles|lipgloss|huh|log|fang|glamour) '` prints nothing.
- REF-289 check: search the code for prints, exits, and config paths.

## Architecture

- **REF-290** Define interfaces in the package that consumes them: the domain core defines its store interface, and adapters implement it. Return concrete types, and add no interface only for mocking (REF-161, REF-231). `[S16]`
- **REF-291** Consider a `go list -deps` test that fails when the domain core depends on CLI, terminal, or Charm packages. `internal/` blocks only imports from other modules, so it does not prevent this (REF-229). `[S16]`

## The `run` function

- **REF-292** Put the signal handler and the error mapping in `run`, and let main only exit with its code. Below `run`, return errors: an exit there skips deferred cleanup and the code map (REF-62, REF-93). `[S13,S15,S16,S17]`
- **REF-293** Recover panics in `run` and in your goroutines: print a bug report with the stack to stderr, and exit 1. An uncaught Go panic exits 2, the usage error code (REF-3). `[S16]`

Notes:

- REF-292, as checked (see `go doc`): fatal log calls and Cobra's check-and-exit helper also exit at once.

Example (REF-292): the startup sequence in order.

```go
func main() {
	os.Exit(run(os.Args[1:])) // os.Exit skips deferred calls, so main only exits
}

func run(args []string) (code int) {
	defer func() { // a crash exits 1, not 2
		if r := recover(); r != nil {
			_, _ = fmt.Fprintf(os.Stderr, "Error: internal error: %v\nPlease report this bug.\n%s", r, debug.Stack())
			code = exitError
		}
	}()
	catchSIGPIPE() // Unix only: EPIPE in place of death by SIGPIPE
	pre := prescan(args)
	if err := normalizeColorEnv(pre.noColor); err != nil { // one NO_COLOR value
		_, _ = fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		return exitError
	}
	ctx, stop := notifyContext(context.Background()) // a signal becomes the cancel cause
	defer stop()

	a := newApp(pre) // the writers, after the env is final
	root := a.rootCmd()
	root.SetArgs(args)
	err := fang.Execute(ctx, root,
		fang.WithVersion(buildVersion()), // REF-329
		fang.WithoutManpage(),            // the tree has its own man command
		fang.WithErrorHandler(func(io.Writer, fang.Styles, error) {}),
	)
	if a.err != nil { // the first recorded error wins
		err = a.err
	}
	if sig := signalCause(ctx); sig != 0 { // a signal wins over the errors it caused
		return 128 + sig
	}
	if err == nil {
		return exitOK
	}
	e := classify(err) // the one place that maps errors to codes
	a.renderError(e)   // REF-304
	return e.Code
}
```

## Commands, flags, and help

- REF-21: For a missing arg, put concise help in the usage error (exit 2): the short description, one example, key flags, and `<cmd> --help`. A bare root call shows help with exit 0.
- REF-68: Use `-d, --debug`, not the counting `-v` of the Cobra user guide. As checked, Cobra's version flag takes a free `-v`, which REF-68 allows. Check: `<tool> -v` prints the version.
- REF-28, REF-29: In your root args validator (REF-303), call Cobra's suggestion function with a minimum distance above zero. As checked, at zero it finds prefix matches but no typos. Check: `<tool> lsit` suggests `list`.
- REF-34: As checked, Cobra adds the completion commands, and fang a hidden man page command, after your guards. So add the completion commands before the guards, and replace fang's man page with your own hidden `man` command, built from the root command with the man page library. Check: `<tool> completion bogus` and `<tool> man extra` exit 2, and `mandoc -T lint` accepts the `<tool> man` output.

- **REF-294** Set an args validator on every command. As checked, Cobra's default accepts any number of args, so an extra or mistyped arg is silently ignored (REF-65, REF-86). `[S12]`
- **REF-295** Let `-h` and `--help` win over other flags (REF-4): prescan for them, and show help from the flag error function. As checked, Cobra parses flags before help, so an unknown flag next to `-h` fails. `[S12]`
- **REF-296** With fang, say in the usage text of each value flag that it takes a value (REF-31). As checked, fang's help drops Cobra's value placeholder, so readers cannot tell value flags from switches. `[S13]`
- **REF-297** Check fang's help against REF-26 and REF-87 on the terminals you support, and use Cobra's help where fang's fails them. `[S13]`
- **REF-298** Load config and do other shared setup in one persistent pre-run hook on the root command only: as checked, only the nearest one runs. Inside the hook, skip the config load for commands that need no config (help, completion). Put cleanup in deferred calls, because guards skip post-run hooks after an error (REF-93, REF-305). `[S12]`
- **REF-299** Keep completion functions fast, free of side effects, and silent on stdout except for the completions (REF-2), because they run on every tab. Turn off the file-name fallback where no file name fits (REF-17). `[S12]`

Notes:

- REF-294 check: an extra arg exits 2.
- REF-295 check: `<cmd> <sub> --bogus -h` prints help with exit 0. As checked, Cobra still parses the args, so a `-h` after a value flag stays its value. Check: `<cmd> --<value-flag> -h <arg>` takes `-h` as the value.
- REF-296 check: in piped `--help`, each value flag shows that it takes a value.
- REF-297, as checked: fang pads piped help lines to 120 columns, and on a TTY it first queries the terminal background (about 4 s on a silent terminal). fang replaces the root's help function as it starts, so for Cobra's help, run the tree with Cobra's execute, not fang, and set the version yourself. Check: trailing spaces in piped help, also after you set Cobra's help function, and `--help` time on a silent pseudo-TTY.
- REF-298, as checked: the root hook also runs for `help`, `completion`, and tab completion. Check: they work with `HOME` unset, and a subcommand's persistent pre-run hook hides the root one.
- REF-299, as checked: the file-name fallback is on by default, and fish and PowerShell ignore both Cobra's extension shortcuts and its filter directives. For portable results, filter the file names inside the completion function. Check: press tab in each shell.

## Output and the contract

- REF-6, REF-7: The JSON field tags are the contract, so tag every field and test the shape.
- REF-164: Return the error of every stdout write, so a closed pipe (REF-319) or a full disk gives the right code.

- **REF-300** Write machine output (`--json`, `--plain`) with the standard library only, never through Lip Gloss styles, tables, or renderers. They add ANSI codes (REF-312), and as checked Lip Gloss turns tabs into spaces, which breaks `--plain` (check, Unix: `cat -t` shows tabs as `^I`). `[S15]`
- **REF-301** Make an empty list print `[]` in JSON, not `null` (REF-7). Go encodes a nil slice as `null`, so initialize result slices and test the empty case. `[S16]`

## Errors and exit codes

- REF-62, REF-63: Keep one list of exit code constants in code and in the root help, for example 0 success, 1 runtime error, 2 usage error (also a missing confirmation or terminal, REF-310, REF-320), 3 not found, 130 SIGINT, 141 closed pipe (REF-319), 143 SIGTERM. A "no" at a prompt gets a code only when the map has one.

- **REF-302** Map errors to exit codes in one place in `run` with the CLI error type, by sentinel and typed errors, not message text (REF-3, REF-62). `[S12,S13]`
- **REF-303** Make every parser error a usage error (exit 2, REF-3): wrap each args validator and check required flags and flag groups in it, set a flag error function, and give the root and each group command a run handler. `[S12,S13]`
- **REF-304** Keep errors from fang: install a no-op error handler, guard every callback (REF-305), and render the error in `run` to stderr, as text with a hint or JSON with `--json` (REF-2, REF-11, REF-59). `[S13]`
- **REF-305** Guard every callback (see Guard in Terms). Cobra goes on after a callback returns nil, so without a guard a command runs with args that failed validation (REF-86). `[S12]`

Notes:

- REF-303, as checked: Cobra returns parser errors as plain errors (exit 1). Without a root args validator, it reports an unknown command before any hook runs. It checks its own required-flag and flag-group markers after the pre-run hooks, so use no markers. Check: each kind of usage error exits 2.
- REF-304, as checked: fang's default handler prints a padded, styled block even into a pipe, and ignores `--json`. For any error from Cobra, fang first queries the terminal background on a TTY, also with a no-op handler (REF-87). Parser errors come before Cobra binds `--json`, so take it from the prescan. Check: a bad flag with `--json`, piped, prints only your JSON error, and time each error path on a silent pseudo-TTY.
- REF-305 check: `<tool> rm <id1> <id2> --force` exits 2 and deletes nothing.

Example (REF-303 to REF-305): guarded callbacks, and parser errors as usage errors.

```go
func (a *app) guard(f func(*cobra.Command, []string) error) func(*cobra.Command, []string) error {
	if f == nil {
		return nil
	}
	return func(cmd *cobra.Command, as []string) error {
		if a.err == nil {
			a.fail(f(cmd, as))
		}
		return nil
	}
}

// captureErrors guards every callback of the tree. Commands use only callbacks that return errors.
func (a *app) captureErrors(c *cobra.Command) {
	if !c.Runnable() { // without a run handler, Cobra skips the args validator
		c.RunE = func(c *cobra.Command, _ []string) error { return c.Help() }
	}
	if c.Args != nil {
		c.Args = a.args(c.Args) // also for Cobra's own commands
	}
	c.PersistentPreRunE, c.PreRunE = a.guard(c.PersistentPreRunE), a.guard(c.PreRunE)
	c.RunE = a.guard(c.RunE)
	c.PostRunE, c.PersistentPostRunE = a.guard(c.PostRunE), a.guard(c.PersistentPostRunE)
	for _, sub := range c.Commands() {
		a.captureErrors(sub)
	}
}

// args wraps an args validator and the command's flag rules (required flags, flag groups).
func (a *app) args(v cobra.PositionalArgs, flagRules ...func(*cobra.Command) error) cobra.PositionalArgs {
	return func(cmd *cobra.Command, as []string) error {
		err := v(cmd, as)
		for _, rule := range flagRules {
			if err == nil {
				err = rule(cmd)
			}
		}
		if err != nil {
			a.fail(usageErr(cmd, err)) // exit 2, not 1
		}
		return nil
	}
}
```

Example (REF-288, REF-298, REF-303): the command tree constructor.

```go
// rootCmd builds a fresh tree for each run (REF-288). Guards go on last.
func (a *app) rootCmd() *cobra.Command {
	root := &cobra.Command{Use: "todo",
		Args:              a.unknownCommand,
		PersistentPreRunE: a.setup, // loads config for the commands that need it
	}
	root.SetFlagErrorFunc(a.flagError)                   // help on a prescan hit (REF-295), else a usage error
	root.AddCommand(a.addCmd(), a.listCmd(), a.manCmd()) // own man command: fang adds its own after the guards
	root.InitDefaultCompletionCmd()                      // now: Cobra adds it at execute time, after the guards
	a.captureErrors(root)
	return root
}
```

## Config

- REF-121: As checked, a list in a higher koanf layer replaces the lower list. Document that. Check: set a list in two layers.
- REF-86: Skip koanf's strict merge and its default decode. As checked, the strict merge rejects a TOML whole number over an `int` default and an env string over a bool, without the key. The default decode is weakly typed (`limit = true` gives 1) and ignores unknown keys. A strict decoder config (the load example) rejects both, with the key, but still truncates a float into an int and accepts quoted numbers and bools from the file. Check: a misspelled key and a wrong type each fail.
- REF-20, REF-86: After the merge, decode the values into a typed config value and validate it before a command runs, with an error that names the key.

- **REF-306** Load config layers lowest first, because each load overrides the earlier ones: defaults, system, user, and project files, env vars, flags (REF-121). A file named by a flag or env var replaces the default file. `[S14]`
- **REF-307** Load flags last, and pass the config store to the flag provider, so an unset flag never overrides a lower layer. Keep per-run flags such as `--force` (REF-117) out of the defaults, and load only flags that have one. `[S12,S14]`
- **REF-308** Write your own env var transform: map each name to its flag key, skip empty values, and keep only keys that have a default (REF-13, REF-123). `[S14]`
- **REF-309** Resolve the config path yourself: on Unix, an absolute `$XDG_CONFIG_HOME`, else `$HOME/.config`, also on macOS (REF-119). Fail when `HOME` is empty. Skip only a missing default file, and fail on every other file error. `[S14,S16]`

Notes:

- REF-307, as checked: with the store, an unset flag fills only a key that no lower layer set. Without it, unset flags load nothing. Check: an unset flag keeps a file value.
- REF-308, as checked: by default the env provider keeps keys such as `TODO_STORE` unchanged, and keeps empty values. The README transform maps `_` to the key delimiter, so `TODO_NO_INPUT` misses `no-input`. Read `TODO_NO_COLOR`, if offered, in the REF-313 step, before config loads. A list setting gets an env string as one item (`a,b`), unless the decode splits it (the load example). Check: a test per env var, and `TODO_FORCE=1` changes nothing.
- REF-309, as checked: Go's user config dir function returns `~/Library/Application Support` on macOS, and fits Windows. An empty `HOME` gives a relative path. Check: `HOME` unset gives an error, and `env -i <tool> help` exits 0 (REF-298).

Example (REF-86, REF-306, REF-307, REF-309): load the layers lowest first, flags last, then decode strictly.

```go
k := koanf.New(".")
if err := k.Load(confmap.Provider(defaults, "."), nil); err != nil { // 1 defaults: settings only
	return nil, err
}
err := k.Load(file.Provider(path), toml.Parser()) // 2 config file
missingDefault := errors.Is(err, fs.ErrNotExist) && !named
if err != nil && !missingDefault { // skip only a missing default file
	return nil, fmt.Errorf("read config file %s: %w", path, err)
}
if err := k.Load(env.Provider(".", env.Opt{Prefix: "TODO_", TransformFunc: envKey}), nil); err != nil {
	return nil, err // 3 env vars
}
// 4 flags last: with k, unset flags keep lower values. flagKey skips flags with no default.
if err := k.Load(posflag.ProviderWithFlag(flagSet, ".", k, flagKey), nil); err != nil {
	return nil, err
}
// 5 strict decode: a wrong type or an unknown key fails, with the key
dc := &mapstructure.DecoderConfig{ErrorUnused: true, DecodeHook: mapstructure.ComposeDecodeHookFunc(
	mapstructure.StringToTimeDurationHookFunc(), mapstructure.StringToBasicTypeHookFunc(),
	mapstructure.StringToSliceHookFunc(","))}
var c Config
if err := k.UnmarshalWithConf("", &c, koanf.UnmarshalConf{DecoderConfig: dc}); err != nil {
	return nil, fmt.Errorf("config: %w", err)
}
```

Example (REF-308): an env var transform with an allowlist.

```go
// envKey maps TODO_NO_INPUT to the flag key "no-input". Only keys with a default pass,
// so a per-run flag or a future secret never comes from the env.
func envKey(name, value string) (string, any) {
	key := strings.ReplaceAll(strings.ToLower(strings.TrimPrefix(name, "TODO_")), "_", "-")
	if _, ok := defaults[key]; !ok || value == "" {
		return "", nil
	}
	return key, value // a string: the strict decode converts it (a list splits at commas), or names the key
}
```

## Interactivity and prompts

- REF-123, REF-277: Turn on huh's accessible (line) mode from a tool-prefixed env var or a config setting.
- REF-76: Read a password with echo off, after the TTY check of REF-310. Save the terminal state first, and restore it on a signal: as checked, the read restores echo only when it returns. Check (Unix): SIGINT during the read leaves echo on.

- **REF-310** Run the REF-8 check yourself before you build the form, and also require a TTY stderr, because a prompt on a redirected stderr is invisible. When prompts are off, fail with a usage error (REF-10). `[S15]`
- **REF-311** Send prompts to stderr, and pick the mode yourself: line mode through the stderr writer for `TERM=dumb` or the accessible setting (REF-123), else the full-screen form (REF-2, REF-12). End line mode when the context ends (REF-114). `[S15]`

Notes:

- REF-310, as checked: huh runs Bubble Tea, which opens `/dev/tty` on Unix when stdin is not a TTY, so a piped or agent run still prompts. Check (Unix): on a terminal, `</dev/null` and `2>err.log` each give a usage error.
- REF-311, as checked: for `TERM=dumb`, huh picks line mode itself, but prompts on stdout with raw ANSI codes. Line mode ignores the context, so after Ctrl-C the prompt keeps waiting. The full-screen form returns a user-abort error for Ctrl-C, and a timeout error for SIGTERM. Check: Ctrl-C and SIGTERM give 130 and 143 in both modes.

Example (REF-310, REF-311): the prompt gate and the prompt mode.

```go
tty := term.IsTerminal(int(os.Stdin.Fd())) && term.IsTerminal(int(os.Stderr.Fd()))
if a.noInput || !tty { // a prompt on a redirected stderr is invisible
	return false, cliError{Code: exitUsage, Kind: "confirmation_required",
		Msg: "refusing to delete " + id + " without confirmation", Hint: "Pass --force to delete without a prompt."}
}
form := huh.NewForm(huh.NewGroup(huh.NewConfirm().Title(title).Value(&ok))).WithInput(os.Stdin)
if os.Getenv("TERM") != "dumb" && !a.accessible { // the full-screen form needs the file itself
	err := form.WithOutput(os.Stderr).RunWithContext(ctx)
	return ok, err
}
done := make(chan error, 1) // line mode ignores ctx, so wait for the answer or the signal
go func() { done <- form.WithAccessible(true).WithOutput(a.stderr).RunWithContext(ctx) }()
select {
case err := <-done:
	return ok, err
case <-ctx.Done():
	return false, context.Cause(ctx) // the signal cause: exit 130 or 143
}
```

## Color and styling

- REF-12: As checked, with `NO_COLOR` colorprofile removes color but keeps bold and faint, which no-color.org allows, and leaves bare reset codes (`ESC[m`) on a TTY. To print no codes, skip styling when the writer's profile has no color. Check: on a pseudo-TTY with `NO_COLOR=1`, look for `ESC[`.

- **REF-312** Print styled output only through the writers, created after the env is final (REF-12, REF-36). As checked, a Lip Gloss style with colors or text attributes renders ANSI codes, so plain `fmt` printing leaks them into a pipe. `[S15]`
- **REF-313** Before fang runs and before any writer or logger exists, set `NO_COLOR=1` when `NO_COLOR` is not empty or the prescan found `--no-color`. The libraries that detect color then follow REF-12 from one env value. `[S15]`
- **REF-314** Use charm log only for `-d, --debug` output, on your own stderr logger. Write normal messages to stderr with plain `fmt`, because, as checked, log lines carry level labels (REF-45). `[S15]`
- **REF-315** Query the terminal background only on a TTY when light or dark matters, and prefer colors that work on both. A terminal that does not answer delays output by seconds (REF-87). `[S15]`

Notes:

- REF-312, as checked: colorprofile writers, fang, charm log, huh's full-screen form, and Bubble Tea follow color detection. Rendered style strings, Glamour, huh's line mode on its default output, and Lip Gloss's package-level print functions (they read the env at start) do not. Check: pipe every command into `cat -v`.
- REF-313, as checked: colorprofile reads `NO_COLOR` as a boolean, so `NO_COLOR=yes` keeps color, and no Charm library adds `--no-color`. Check: on a pseudo-TTY, `NO_COLOR=yes`, `NO_COLOR=1`, and `--no-color` give no color codes.
- REF-314, as checked: the package-level logger also adds timestamps. Check: normal messages in a pipe have no label.
- REF-315, as checked: each query waits up to 2 s. Lip Gloss's compatibility package for adaptive colors reads stdin and stdout globally, so keep it out of new code. Check: time the first styled output on a silent pseudo-TTY.
- Windows, as checked: fang turns on escape code processing for stdout and stderr. Without fang, or before it runs, turn it on yourself (Lip Gloss has a helper). Check: the Windows console shows no raw codes.

Example (REF-312, REF-313): one `NO_COLOR` value, then one writer per stream.

```go
// normalizeColorEnv runs before fang and before any writer or logger exists.
func normalizeColorEnv(noColorFlag bool) error {
	if noColorFlag || os.Getenv("NO_COLOR") != "" {
		return os.Setenv("NO_COLOR", "1") // colorprofile parses NO_COLOR as a bool
	}
	return nil
}

// newApp creates one writer per stream, after the env is final. Commands print
// styled text only through these writers.
func newApp(pre prescanned) *app {
	return &app{pre: pre,
		stdout: colorprofile.NewWriter(os.Stdout, os.Environ()),
		stderr: colorprofile.NewWriter(os.Stderr, os.Environ()),
	}
}
```

## Signals, context, and cleanup

- REF-93: Go's rename is atomic only on Unix, so a temp file plus a rename is an atomic write only there.
- REF-116: On Windows, list interrupt and SIGTERM in the handler: Go delivers console close events as SIGTERM. Windows still ends the process, so keep cleanup short.

- **REF-316** Pass the context from `run` down every call that does I/O or waits (REF-91, REF-114). A fresh background context below `run` ignores Ctrl-C. `[S16]`
- **REF-317** Handle SIGINT and SIGTERM in `run`: cancel the root context with the signal as its cause, and exit 128 plus the signal number (REF-114, REF-116). `[S13,S16]`
- **REF-318** To meet REF-115, after the first signal, stop the notification so the second one gets Go's default exit, or catch it and exit at once. `[S16]`
- **REF-319** To meet REF-164 on Unix, catch SIGPIPE at the start of `run`, in place of ignoring it. A write to a closed stdout or stderr then returns an error, not death by SIGPIPE. Child processes inherit an ignored signal, but not a caught one. `[S16]`

Notes:

- REF-317: without a handler, Go exits at once and skips deferred cleanup. As checked, fang's notify option drops which signal arrived, so the run exits 1. Check (Unix): SIGINT and SIGTERM give 130 and 143 after cleanup.
- REF-318: to test the second-signal path, put a hook that slows cleanup behind a build tag, so release builds lack it.
- REF-319: on EPIPE, stop writing and exit quietly, for example with 141 (128 + SIGPIPE). Keep SIGPIPE out of the handler of REF-317. Check (Unix): a long output piped into `head -1` exits with the mapped code, silently, and a child `yes | head -1` exits 141.

Example (REF-317, REF-318): the signal handler.

```go
// notifyContext cancels ctx on the first SIGINT or SIGTERM, with the signal as the cause.
func notifyContext(parent context.Context) (context.Context, func()) {
	ctx, cancel := context.WithCancelCause(parent)
	ch := make(chan os.Signal, 2) // buffered: the signal package does not block to send
	signal.Notify(ch, os.Interrupt, syscall.SIGTERM)
	go func() {
		s, ok := <-ch
		if !ok {
			return
		}
		cancel(signalError{sig: s.(syscall.Signal)}) // run reads the cause and exits 128 + sig
		// a second signal skips cleanup: the one exit below run
		if s, ok = <-ch; ok {
			_, _ = fmt.Fprintln(os.Stderr, "Second signal received. Quitting without cleanup.")
			os.Exit(128 + int(s.(syscall.Signal)))
		}
	}()
	return ctx, func() { signal.Stop(ch); close(ch); cancel(nil) }
}
```

Example (REF-319): SIGPIPE on Unix.

```go
// In a file with the "unix" build constraint. Its "!unix" twin has an empty catchSIGPIPE, and its
// pipeClosed matches ERROR_NO_DATA (232, not run on Windows). Notify, not Ignore: children inherit Ignore.
func catchSIGPIPE() { signal.Notify(make(chan os.Signal, 1), syscall.SIGPIPE) }

// pipeClosed reports a write error after the reader went away. classify maps it to a code.
func pipeClosed(err error) bool { return errors.Is(err, syscall.EPIPE) }
```

## TUI

- REF-239: In the v2 line, the view declares the terminal modes, and the runtime sets and restores them. As checked, bracketed paste is on unless the view turns it off, and key disambiguation is always on while the program reads input. Check: the start bytes on a pseudo-TTY.
- REF-243: In raw mode, Ctrl-C is a key press, not SIGINT, so bind it in update. Check: Ctrl-C on a pseudo-TTY quits the TUI.
- REF-2: Send an error from the program run through the CLI error path to stderr, not to stdout as the Bubble Tea tutorial does.
- REF-114, REF-316: Pass the CLI command's context to the program, and keep it in the model, because, as checked, the model's init takes no context (see `go doc`).

- **REF-320** Run the REF-238 check yourself before you start a Bubble Tea program. If it fails, return a usage error that names the CLI command for the same data. `[S15]`
- **REF-321** Keep Bubble Tea's panic recovery on, and map its panic error to exit 1 as in REF-293 (REF-241, REF-242). In your own goroutines, recover and send the failure to the program as a message. `[S15]`

Notes:

- REF-320, as checked: Bubble Tea opens the terminal device when stdin is not a TTY, and with stdout piped it writes escape codes into the pipe. Check: the TUI piped into `cat` gives a usage error.
- REF-321, as checked: Bubble Tea restores the terminal and prints the stack for panics in update, view, and TUI commands, but not in goroutines that you start. Check: compare the terminal mode before and after each panic.
- REF-321, as checked: Bubble Tea also catches SIGINT and SIGTERM, may return nil for SIGTERM, and wraps its panic error in its killed error. So test the signal cause first, then the panic error, then the interrupt error (130). Check (Unix): SIGINT, SIGTERM, and a panic exit 130, 143, and 1.

## Testing

- REF-144, REF-147: Register `run` as a testscript command in the test main (example below, as checked: see `go doc`). The test binary then runs the CLI as its own child process, with no build step.
- REF-283, REF-284: teatest runs the real loop in memory with a fixed window size, types keys, and returns the final model (as checked, see `go doc`).

- **REF-322** Test the contract on the built binary, through pipes and a pseudo-TTY: streams, exit codes, no escape codes in pipes, color controls, no prompt or TUI without a TTY, signals, and the terminal mode after exit. `[S16,S17]`
- **REF-323** Give every test a child env that starts empty, and a temp HOME and XDG dirs (on Windows `USERPROFILE`, `APPDATA`, `LOCALAPPDATA`). Otherwise `NO_COLOR`, the tool's env vars, and real config leak in (REF-145). `[S16,S17]`
- **REF-324** Check exact exit codes in script tests with a custom command (REF-62). As checked, testscript's negation only checks for a non-zero code. `[S17]`
- **REF-325** Consider comparing the final TUI screen, with escape codes stripped, against a golden file, in place of the raw output. A renderer change then does not break the test (REF-283). `[S15]`
- **REF-326** When you fuzz, target pure parse and validation functions of the domain core, not the whole process, because targets must be fast and deterministic. Commit failing inputs in `testdata/fuzz`, and bound fuzz time in CI. `[S16]`

Notes:

- REF-322, as checked: the testscript child fits streams, exit codes, env, and files. Its stdin is never a TTY and its build info differs, so test TTY behavior, signals, and `--version` against the built binary. Check: `--version` in a script and in the binary.
- REF-322, as checked: pseudo-TTY tests run on Unix only (use the `unix` build constraint), and Bubble Tea's start-up queries show up in captures. On macOS, read the terminal mode through the test's side. Set `TERM`: colorprofile treats a missing `TERM` as no color. Check: `GOOS=windows go vet ./...`, and a pseudo-TTY run without `TERM`.
- REF-323: set the child's env, not the test's (the set-env helper blocks parallel tests). As checked, testscript gives each script a fake HOME (`exec env` shows it), so set the XDG vars in its setup.
- REF-324 check: `! exec` passes for exit 1 and 2.

Example (REF-144, REF-324): register the CLI, and check exact exit codes.

```go
func TestMain(m *testing.M) {
	testscript.Main(m, map[string]func(){
		"todo": func() { os.Exit(run(os.Args[1:])) },
	})
}

// exitCode backs the script command "exitcode N cmd args...".
func exitCode(ts *testscript.TestScript, neg bool, args []string) {
	if neg || len(args) < 2 { // "! exitcode" would invert nothing, so refuse it
		ts.Fatalf("usage: exitcode N cmd [args...]")
	}
	want, err := strconv.Atoi(args[0])
	ts.Check(err)
	got := 0
	var ee *exec.ExitError
	if err := ts.Exec(args[1], args[2:]...); errors.As(err, &ee) {
		got = ee.ExitCode()
	} else if err != nil {
		ts.Fatalf("exitcode: %v", err)
	}
	if got != want {
		ts.Fatalf("exit code %d, want %d", got, want)
	}
}
```

Example (REF-322): a pseudo-TTY test of the built binary, on Unix.

```go
func TestCtrlCAtPrompt(t *testing.T) {
	bin, env, id := sandbox(t)   // the built binary, an env with HOME, XDG dirs, TERM, and an item
	ptmx, tty, err := pty.Open() // the test keeps the terminal side, the CLI gets tty
	if err != nil {
		t.Fatal(err)
	}
	defer func() { _ = ptmx.Close() }()
	before, _ := term.GetState(int(ptmx.Fd())) // read through ptmx: macOS revokes tty on exit
	cmd := exec.Command(bin, "rm", id)
	cmd.Env, cmd.Stdin, cmd.Stdout, cmd.Stderr = env, tty, tty, tty
	cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true, Setctty: true} // tty is the controlling terminal
	if err := cmd.Start(); err != nil {
		t.Fatal(err)
	}
	_ = tty.Close()                              // the child has its own copy
	readUntil(t, ptmx, "Delete", 10*time.Second) // wait for the prompt, with a deadline
	_, _ = ptmx.Write([]byte{3})                 // Ctrl-C: SIGINT, or a key press in raw mode
	_ = cmd.Wait()
	after, _ := term.GetState(int(ptmx.Fd()))
	if code := cmd.ProcessState.ExitCode(); code != 130 || *after != *before {
		t.Fatalf("exit %d, want 130, terminal mode restored: %v", code, *after == *before)
	}
}
```

## Tooling and checks

- **REF-327** Fail CI on a dirty `go mod tidy` diff (REF-234). Consider gating on checks like those in the table, with unchecked errors as lint errors, because a dropped error becomes a wrong exit code (REF-232). `[S16,S19]`
- **REF-328** Run govulncheck on all packages in CI, before each release, and on a schedule. Block on findings that your code calls (REF-233, REF-234). `[S16]`

Notes:

- REF-327, as checked: the race detector needs cgo on Linux and Windows. Check: `GOOS=linux CGO_ENABLED=0 go test -race -c` fails. Mark each best-effort stderr write as ignored on purpose, so the unchecked-error check stays at zero.
- REF-328: upgrade a vulnerable indirect module itself (`go get <module>@<fixed version>`), not every module with `go get -u ./...`.

Example (REF-327 to REF-329): checks and release commands.

| Command | What it checks or does | When |
|---|---|---|
| `go vet ./...`, `go test -race ./...` | Suspicious constructs, data races | Every change |
| golangci-lint | Many analyzers, and formatting once configured (as checked, staticcheck is a default: `golangci-lint linters`) | Every change |
| govulncheck, `go mod tidy -diff` | Known vulnerabilities that the code calls, a clean go.mod | CI, release, schedule |
| `go build -ldflags "-X main.version=..."` | Stamps the version at link time | Release builds |
| GoReleaser `check`, `release --snapshot` | Checks the config, builds without publishing | Pull requests, release |

## Release

- REF-131, REF-233: Release with GoReleaser. Pure-Go builds with cgo off give one static binary for a clean machine.
- REF-234: Scripts read the artifact list, because dist directory names may change between GoReleaser versions (the docs give no guarantee). Check: compare them after an upgrade.

- **REF-329** Build `--version` from build info: a version set at link time, else the main module version, else "(devel)" with the VCS revision and a dirty mark. Pass it to fang (REF-34). `[S13,S16,S18]`
- **REF-330** From v2 on, put the major version suffix in the module path and in every import, also for a CLI-only module. Go module versions follow the Go API. The CLI contract follows REF-106 and REF-107. `[S16]`

Notes:

- REF-329, as checked: `go install`, and `go build` in a VCS checkout, set the main module version. fang's default uses it only with a module checksum, so local builds show "unknown (built from source)". A link-time name that does not match the release config fails silently. Check: `--version` of a stamped build.

## Not covered

- Windows: named pipes for IPC, ConPTY tests, signal exit codes, and mintty, where TTY checks see a pipe.
- A shell may start the CLI in the background with SIGINT ignored, and registering SIGINT turns it back on.
- Re-raising SIGINT after cleanup (bash expects it to stop a loop), and SIGHUP.
- Packaging beyond the GoReleaser quick start: signing, SBOMs, package managers, and uninstall steps (REF-132).

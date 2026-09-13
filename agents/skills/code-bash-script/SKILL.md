---
name: code-bash-script
description: Writes, reviews, and refactors small Bash scripts with flat happy-path flow and proportional safeguards. Use for `.sh` files, Bash startup files such as `.bashrc`, CLI wrappers, setup or install scripts, argument parsing, and strict mode.
---

# Code Bash Script

Use Bash for small utilities and wrappers that mostly call other programs. Past about 100 lines or non-trivial control flow, use a structured language.

## Default

Use proportional safeguards. Start with flat, direct happy-path code. Add validation, custom errors, recovery, and idempotency only when the interface or failure risk justifies them.

Distinguish the file before writing:

- Executable Bash script: use a shebang and strict mode.
- Sourced file such as `.bashrc`: preserve the caller's shell options and use `return` for early completion.

## Executable Layout

Order an executable script as needed:

1. Shebang and strict mode
2. Globals and constants
3. Argument parsing, only for a real option interface
4. Necessary validation
5. Shared or non-trivial functions
6. Flat procedural logic

```bash
#!/usr/bin/env bash
set -euo pipefail
```

Use `#!/usr/bin/env bash` so the environment selects Bash instead of forcing the older Bash at `/bin/bash` on macOS.

Use uppercase names for environment-overridable globals and true constants. Use lowercase names for working values. Mark stable constants `readonly` when doing so clarifies their role.

```bash
readonly TOOL_BIN="/opt/tool/bin/tool"
DRY_RUN="${TOOL_DRY_RUN:-0}"
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
```

## Failure Handling

Treat `set -euo pipefail` as a backstop. Run ordinary commands directly when their own diagnostics identify the failure:

```bash
mkdir -p "$target_dir"
curl -fsSL "$url" -o "$archive"
tar -xf "$archive" -C "$target_dir"
```

Handle a status explicitly when it is expected, selects behavior, permits best-effort cleanup, or needs a more actionable error.

Define `die` only when at least two call sites need consistent errors or a public interface benefits from it:

```bash
die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}
```

Keep these strict-mode boundaries in mind:

- Commands tested by `if`, `&&`, or `||` are status-controlled. Check important failures inside any function called from those contexts.
- Command substitutions do not inherit `-e` by default. Add `shopt -s inherit_errexit` on Bash 4.4+ only when a substitution failure must abort.
- With `pipefail`, an expected no-match or early pipe exit can fail the pipeline. Handle that expected status at its call site.
- Under `-u`, use `"${1:-}"` and `"${VAR:-default}"` for values that may be unset.

## Flat Control Flow

Keep the procedural path unindented. Use terminal guards and single-purpose status chains:

```bash
[[ -f "$marker" ]] && exit 0
[[ -x "$TOOL_BIN" ]] || "$installer" --non-interactive
[[ "$DRY_RUN" == "1" ]] && args+=(--dry-run)
```

Use action selection or an explicit branch for two-way behavior:

```bash
action=update
tool inspect "$name" >/dev/null 2>&1 || action=create
tool "$action" "$name"
```

Avoid using `A && B || C` as a ternary because a failure in `B` also runs `C`. Use `if` when both branches contain meaningful multi-command work or when the distinction between their failures matters.

Keep branch depth at one. Replace deeper branches with early exits, action selection, or a function that isolates genuinely non-trivial behavior. A required `while`/`case` option parser is structural rather than branch nesting.

## Inputs And Arguments

Keep a fixed-behavior script parser-free. Pass operands with `"$@"` when the wrapper intentionally forwards them. Reject unexpected arguments only when accepting them would hide a user mistake.

When the script accepts flags or options, read [references/arguments.md](references/arguments.md) before implementing the interface.

Validate external input, destructive targets, and assumptions whose native failure would be unclear or too late. Let the next command report a clear, harmless failure instead of duplicating its check.

## Installation And State

Confirm the current vendor-supported installation procedure before encoding it. Preserve the official command sequence and add only the non-interactive adaptation the environment needs.

Use the amount of repeatability the script promises:

- Disposable development setup: assume a clean happy path when rebuilding is safe.
- Rerunnable provisioning: use naturally idempotent commands or a successful-completion marker.
- Critical recovery: make each state change safe to retry; a marker alone cannot recover partial work.

A one-time provisioning marker stays minimal:

```bash
[[ -f "$MARKER" ]] && exit 0

run_provisioning

touch "$MARKER"
```

Create the marker last so a failed run remains eligible for another attempt.

## Functions, Comments, And Bash Rules

- Add a function when multiple call sites share meaningful behavior or when it isolates non-trivial logic.
- Declare function variables `local`. Separate declaration from command substitution because `local value=$(cmd)` masks the command's status.
- Consider `main "$@"` once the script needs multiple functions.
- Send errors and progress to stderr. Reserve stdout for the script's result.
- Comment hidden reasons, constraints, and risks. An obvious script needs no comments beyond its shebang.
- Double-quote expansions: `"$value"`, `"$@"`, and `"${array[@]}"`.
- Build command arguments in arrays, append conditionally, and expand the array quoted.
- Use `[[ ]]` for tests and `(( ))` for arithmetic.
- Use `$(cmd)` instead of backticks.
- Use `printf '%s\n'` when output contains data. `echo` is fine for a fixed literal.
- Feed loops with process substitution or `readarray`; a piped `while` loop loses assignments in a subshell.
- Iterate files with globs or `find ... -print0`; never parse `ls`.
- Put `--` before filename operands and use explicit paths so names starting with `-` stay operands.
- Use `mktemp` and an `EXIT` trap for temporary state.

## Verify

Run static checks on every changed Bash file:

```bash
bash -n path/to/script.sh
shellcheck path/to/script.sh
shfmt -d path/to/script.sh
```

Use `shfmt -w` only as an intentional formatting edit, then rerun `shfmt -d`.

Run the happy path and every changed conditional path when the test is safe and authorized. For setup code, test a clean installation. Test a second run or restart only when the script claims repeatability.

The work is done when all applicable static checks exit zero and runtime behavior has an observable success signal. Name any runtime path that could not be tested.

## Sources

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Greg's Wiki: BashPitfalls](https://mywiki.wooledge.org/BashPitfalls), [BashFAQ/035](https://mywiki.wooledge.org/BashFAQ/035), [BashFAQ/105](https://mywiki.wooledge.org/BashFAQ/105)
- [ShellCheck wiki](https://www.shellcheck.net/wiki/)

---
name: code-bash-script
description: Guide for writing robust bash scripts. Use when creating, reviewing, or refactoring any shell script (.sh file, bin script, CLI wrapper, install/setup script), or when handling flags, arguments, or strict mode in bash.
---

# Code Bash Script

Bash is for small utilities and wrapper scripts that mostly call other programs. Past ~100 lines or non-trivial control flow (Google's rule), rewrite in a structured language instead of growing the script.

## Script Layout

Order every script the same way, top to bottom:

1. Shebang and strict mode
2. UPPERCASE globals and constants
3. Minimal helper functions (`usage`, `die`)
4. Flag and argument parsing
5. Validation, so the script fails before any logic runs
6. Flat procedural logic

```sh
#!/usr/bin/env bash
set -euo pipefail
```

Use `#!/usr/bin/env bash`, not `#!/bin/bash`: macOS/BSD ship bash outside `/bin` or ship ancient 3.2.

## Strict Mode

`set -euo pipefail` is a backstop, not error handling. Its known leaks:

- `-e` is disabled inside `if`/`&&`/`||` contexts and in any function called from one.
- Command substitutions don't inherit `-e`; add `shopt -s inherit_errexit` (bash 4.4+) when it matters.
- `pipefail` breaks legitimately-failing pipeline stages (`grep` with no match, SIGPIPE from `head`); handle expected failures with `cmd || true`.
- Under `-u`, use `"${1:-}"` / `"${VAR:-default}"` for legitimately-maybe-unset variables.

So still check every command whose failure matters explicitly: `cmd || die "message"`.

## Globals And Constants

- ALL_CAPS with underscores, defined at the very top. Everything else lowercase.
- Make env-overridable values default with parameter expansion: `DRY_RUN="${DOTFILES_DRY_RUN:-0}"`.
- Mark true constants `readonly`.
- Derive script location once: `SCRIPT_DIR="$(dirname -- "$(realpath "${BASH_SOURCE[0]}")")"`.

## Helper Functions

Define only the helpers the script needs, right after the globals. The two standard ones:

```sh
usage() { printf 'Usage: %s [-n|--dry-run] [--] PROFILE\n' "${0##*/}"; }
die() {
	printf 'Error: %s\n' "$1" >&2
	usage >&2
	exit 1
}
```

- Errors and progress messages go to stderr; stdout is reserved for the script's actual output.
- In functions, declare variables `local`, and separately from command-substitution assignment: `local x=$(cmd)` masks the exit code (SC2155). Write `local x; x=$(cmd)`.
- Once a script has more than one non-helper function, end it with a `main` function invoked as `main "$@"` on the last line.

## Flags And Arguments

Use a manual `while`/`case` loop, the only portable way to get `--long` flags, `--opt=value`, and custom errors (Greg's Wiki BashFAQ/035). `getopts` is acceptable for short-options-only scripts; never use external `getopt(1)` (the BSD/macOS version mangles arguments containing spaces).

Set defaults before the loop so flags override them. The canonical loop:

```sh
file=""
verbose=0

while :; do
	case "${1-}" in
	-h | --help)
		usage
		exit 0
		;;
	-f | --file)
		[[ ${2-} ]] || die '"--file" requires a non-empty argument'
		file=$2
		shift
		;;
	--file=?*) file=${1#*=} ;;
	--file=) die '"--file" requires a non-empty argument' ;;
	-v | --verbose) verbose=$((verbose + 1)) ;;
	--)
		shift
		break
		;;
	-?*) die "unknown option: $1" ;;
	*) break ;;
	esac
	shift
done
```

Conventions to honor:

- When the user requests `--help`, print usage to **stdout** and exit 0. On a bad invocation, print the error and usage to **stderr** and exit non-zero.
- `--` ends option parsing; everything after is an operand.
- Reject unknown flags and empty option-arguments; don't ignore them.

## Validate Before Logic

After parsing, check every precondition and fail with a specific message before any work happens (negative-space programming):

```sh
[[ "$file" ]] || die "--file is required"
[[ -d "$TARGET_DIR" ]] || die "target directory is missing: $TARGET_DIR"
```

Once the logic starts, every input is already known-good, so the logic reads as a flat procedure.

## Flat Logic, No Nesting

- Use guard clauses and early `exit` instead of `if/else` pyramids. A branch that ends the script (`--delete` mode, dry-run) does its work and exits; the main path continues unindented.
- Build command argument lists in arrays, never in strings; append conditionally and expand quoted:

```sh
flags=(--target="$HOME" --verbose=1)
[[ "$DRY_RUN" == "1" ]] && flags+=(-n)
stow "${flags[@]}" --restow "$package"
```

## Language Rules

- Double-quote every expansion: `"$var"`, `"$@"`, `"${array[@]}"` (SC2086). Use `"$@"` never `$*`.
- `[[ ]]` for tests, `(( ))` for arithmetic: `[[ $x > 7 ]]` compares strings lexicographically.
- `$(cmd)` never backticks.
- `printf '%s\n'` over `echo` for anything but fixed literal text: `echo` mangles `-n`, `-e`, backslashes.
- Never pipe into `while`: the loop runs in a subshell and assignments vanish. Use `done < <(cmd)` or `readarray -t`.
- Never parse `ls`; use globs (`for f in ./*.sh`) or `find ... -print0`.
- Use `--` before filename arguments (`rm -- "$file"`) and explicit paths (`./*` not `*`) so names starting with `-` aren't taken as flags.
- Handle `cd` failure: `cd "$dir" || die "cannot cd to $dir"`.
- If the script creates temp state, use `tmp=$(mktemp)` plus `trap 'rm -f "$tmp"' EXIT`. Never hardcode `/tmp/name`.

## Verify

Before considering the script done, run both and fix every finding:

```sh
shellcheck path/to/script.sh
shfmt -w path/to/script.sh
```

## Sources

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Greg's Wiki: BashPitfalls](https://mywiki.wooledge.org/BashPitfalls), [BashFAQ/035 (arguments)](https://mywiki.wooledge.org/BashFAQ/035), [BashFAQ/105 (set -e)](https://mywiki.wooledge.org/BashFAQ/105)
- [ShellCheck wiki](https://www.shellcheck.net/wiki/)
- [Minimal safe Bash script template](https://betterdev.blog/minimal-safe-bash-script-template/)

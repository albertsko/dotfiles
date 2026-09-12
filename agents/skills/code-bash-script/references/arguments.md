# Bash Argument Parsing

Read this reference only when a Bash script accepts flags or options. Fixed-behavior scripts and pass-through wrappers do not need a parser.

## Default Parser

Use a manual `while`/`case` loop for long options, `--option=value`, and custom errors. Use `getopts` only for a short-options-only interface. BSD and GNU `getopt(1)` differ, so it is not a portable default.

Set defaults before parsing so options override them. Assume `die` prints its argument to stderr and exits non-zero.

```bash
file=""
verbose=0

while :; do
	case "${1-}" in
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

## Interface Rules

- Support only the flags the script needs.
- Treat `--` as the end of options and preserve every following operand.
- Reject unknown flags and empty option arguments.
- Add `-h` or `--help` when requested or when a non-trivial public interface needs discoverable usage.
- Print help to stdout and exit zero.
- Print bad-invocation errors to stderr and exit non-zero. Include usage only when it helps resolve the error.
- Validate the final operand count before the procedural logic starts.

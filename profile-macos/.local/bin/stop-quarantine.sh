#!/usr/bin/env bash
set -euo pipefail

[[ "$(uname -s)" == "Darwin" ]] || {
	echo "macOS only" >&2
	exit 1
}
[[ $# -eq 1 ]] || {
	echo "usage: $0 <cmd-or-path>" >&2
	exit 2
}

cmd="$1"

if [[ "$cmd" == */* ]]; then
	path="$cmd"
else
	path="$(command -v "$cmd" || true)"
fi

[[ -n "${path:-}" && -e "$path" ]] || {
	echo "not found: $cmd" >&2
	exit 3
}

target="$(realpath "$path")"

sudo xattr -dr com.apple.quarantine "$target"
echo "unquarantined: $target"

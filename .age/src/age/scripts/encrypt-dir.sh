#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/_utils"

require_tool age
require_tool tar

if test "$#" -ne 2; then
	echo "usage: encrypt-dir.sh INPUT_DIR OUTPUT" >&2
	exit 1
fi

input="$1"
output="$2"
error=""
recipient_contents="$(</dev/stdin)"

if ! test -d "$input"; then
	echo "input path '$input' is not a directory" >&2
	exit 1
fi

# Directories are archived as tar.gz before age encryption.
if ! error="$({ tar -C "$input" -czf - . | age -e -R <(echo "$recipient_contents") -o "$output"; } 2>&1)"; then
	echo "$error" >&2
	exit 1
fi

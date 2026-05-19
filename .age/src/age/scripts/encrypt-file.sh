#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/_utils"

require_tool age

if test "$#" -ne 2; then
	echo "usage: encrypt-file.sh INPUT OUTPUT" >&2
	exit 1
fi

input="$1"
output="$2"
error=""
recipient_contents="$(</dev/stdin)"

# age -R expects a recipient file path, so process substitution keeps the
# recipient material off the command line while avoiding a temp file.
if ! error="$(age -e -R <(echo "$recipient_contents") -o "$output" "$input" 2>&1)"; then
	echo "$error" >&2
	exit 1
fi

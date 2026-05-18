#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/_utils"

require_tool age

if test "$#" -ne 2; then
	echo "usage: decrypt-file.sh INPUT OUTPUT" >&2
	exit 1
fi

input="$1"
output="$2"
error=""
tmp_dir="$(mktemp -d)"
identity="$tmp_dir/identity"

cleanup() {
	rm -rf "$tmp_dir"
}

trap cleanup EXIT
trap 'cleanup; exit 1' HUP INT TERM

# age and ssh-keygen reject private keys with loose file permissions.
cat >"$identity"
chmod 600 "$identity"

if ! error="$(age -d -i "$identity" -o "$output" "$input" 2>&1)"; then
	echo "$error" >&2
	exit 1
fi

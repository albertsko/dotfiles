#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/_utils"

require_tool age
require_tool tar

if test "$#" -ne 2; then
	echo "usage: decrypt-dir.sh INPUT OUTPUT_DIR" >&2
	exit 1
fi

input="$1"
output="$2"
error=""
tmp_dir="$(mktemp -d)"
identity="$tmp_dir/identity"

# shellcheck disable=SC2329
cleanup() {
	rm -rf "$tmp_dir"
}

trap cleanup EXIT
trap 'cleanup; exit 1' HUP INT TERM

if test -e "$output" && ! test -d "$output"; then
	echo "output path '$output' exists and is not a directory" >&2
	exit 1
fi

mkdir -p "$output"

# age and ssh-keygen reject private keys with loose file permissions.
cat >"$identity"
chmod 600 "$identity"

# Directory payloads are age-encrypted tar.gz streams.
if ! error="$({ age -d -i "$identity" "$input" | tar -xzf - -C "$output"; } 2>&1)"; then
	echo "$error" >&2
	exit 1
fi

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/_utils"

require_tool age
require_tool age-inspect
require_tool age-keygen

error=""
tmp_dir="$(mktemp -d)"
identity="$tmp_dir/identity"
plain="$tmp_dir/plain"
empty="$tmp_dir/empty"

# shellcheck disable=SC2329
cleanup() {
	rm -rf "$tmp_dir"
}

trap cleanup EXIT
trap 'cleanup; exit 1' HUP INT TERM

# age and ssh-keygen reject private keys with loose file permissions.
cat >"$identity"
chmod 600 "$identity"
: >"$empty"

verify_plain_identity() {
	local path="$1"

	if error="$(age-keygen -y "$path" 2>&1 >/dev/null)"; then
		return 0
	fi

	if ! head -n 1 "$path" | grep -q "BEGIN OPENSSH PRIVATE KEY"; then
		return 1
	fi

	require_tool ssh-keygen

	# Reject encrypted SSH keys early so later age decrypt calls cannot prompt.
	if ! error="$(ssh-keygen -y -P "" -f "$path" 2>&1 >/dev/null)"; then
		return 1
	fi

	if error="$(age -e -i "$path" -o /dev/null "$empty" 2>&1)"; then
		return 0
	fi

	return 1
}

# Inspect age files before plain validation; otherwise age -i can prompt for
# passphrase-protected identity files before batchpass gets a chance.
if ! inspect_json="$(age-inspect --json "$identity" 2>/dev/null)"; then
	if verify_plain_identity "$identity"; then
		cat "$identity"
		exit 0
	fi

	echo "$error" >&2
	exit 1
fi

if [[ "$inspect_json" != *'"scrypt"'* ]]; then
	echo "identity is an age file, but it is not passphrase protected" >&2
	exit 1
fi

require_tool age-plugin-batchpass

if ! error="$(age -d -j batchpass -o "$plain" "$identity" 2>&1)"; then
	echo "$error" >&2
	exit 1
fi

if ! verify_plain_identity "$plain"; then
	echo "$error" >&2
	echo "decrypted identity is not a valid age identity" >&2
	exit 1
fi

cat "$plain"
exit 0

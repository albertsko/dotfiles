#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
source "$SCRIPT_DIR/_utils"

require_tool age

error=""
recipient_contents="$(</dev/stdin)"

# age -R performs the real recipient parser/validator for us.
if ! error="$(age -e -R <(echo "$recipient_contents") -o /dev/null <(echo "") 2>&1)"; then
	echo "$error" >&2
	exit 1
fi

echo "$recipient_contents"

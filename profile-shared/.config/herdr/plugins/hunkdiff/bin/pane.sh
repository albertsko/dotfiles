#!/usr/bin/env bash
set -euo pipefail

# Runs hunk in the review pane. Herdr starts this script in the reviewed worktree;
# the action passes the target through HUNKDIFF_MODE and HUNKDIFF_REF.

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

worktree="$PWD"
mode="${HUNKDIFF_MODE:-working}"
ref="${HUNKDIFF_REF:-}"

target_args "$mode" "$ref"
[[ "$EXPERIMENTAL" == "1" ]] && TARGET_ARGS+=(--experimental)
[[ "$WATCH" == "1" ]] && TARGET_ARGS+=(--watch)
TARGET_ARGS+=("${EXTRA_ARGS[@]}")

# stderr goes to a file: herdr closes the pane on a non-zero exit and takes hunk's error with it.
err_file="$(mktemp)"
bash "$SCRIPT_DIR/watch.sh" "$worktree" "$$" &
watcher=$!
trap 'kill "$watcher" 2>/dev/null || true; rm -f -- "$err_file"' EXIT

status=0
"$HUNK" "${TARGET_ARGS[@]}" 2>"$err_file" || status=$?
kill "$watcher" 2>/dev/null || true
cat -- "$err_file" >&2

unsent="$(unsent_comments "$(load_saved "$worktree")" '[]' "$(sent_ids "$worktree")" | jq length)"
[[ "$unsent" != "0" ]] &&
	notify "hunk closed with $unsent unsent review comment(s). They were saved; run send-review to deliver them."

if [[ "$status" != "0" ]]; then
	# Last three non-empty lines without terminal escapes, capped for a one-line notification.
	detail="$(sed $'s/\033\\[[0-9;?]*[ -/]*[@-~]//g' "$err_file" | grep -v '^[[:space:]]*$' | tail -n 3 | paste -sd '/' - || true)"
	((${#detail} <= 300)) || detail="…${detail: -300}"
	notify "hunk exited $status for the $mode review of $worktree${ref:+ at $ref}${detail:+: $detail}"
fi

exit "$status"

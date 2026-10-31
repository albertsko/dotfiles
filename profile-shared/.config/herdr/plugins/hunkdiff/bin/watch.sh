#!/usr/bin/env bash
set -euo pipefail

# Saves the unsent user comments of a live review every few seconds, so send-review can
# deliver them after hunk closes. Usage: watch.sh WORKTREE PARENT_PID

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

worktree="$1"
parent="$2"

# Comments saved by an earlier viewer stay saved until they are sent.
carried="$(load_saved "$worktree")"

# The pane stops this script when hunk exits; the parent check covers a killed pane.
while kill -0 "$parent" 2>/dev/null; do
	# The session may not be up yet, or already gone; keep the last snapshot then.
	if list_user_comments "$worktree"; then
		save_comments "$worktree" "$(unsent_comments "$carried" "$COMMENTS" "$(sent_ids "$worktree")")"
	fi
	sleep 3
done

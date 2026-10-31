#!/usr/bin/env bash
# shellcheck disable=SC2016 # jq filters use $variables
set -euo pipefail

# Handles herdr event hooks: agent status, pane exit or close, and worktree removal.

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

event_json="${HERDR_PLUGIN_EVENT_JSON:-}"
[[ -n "$event_json" ]] || exit 0

field() {
	jq -r "$1 // empty" <<<"$event_json" 2>/dev/null || true
}

# Prints the git root of the agent running in a pane, from `herdr agent list`.
worktree_for_pane() {
	local cwd
	cwd="$("$HERDR" agent list 2>/dev/null | jq -r --arg p "$1" \
		'.result.agents[]? | select(.pane_id == $p) | .cwd // empty' 2>/dev/null | head -n 1 || true)"
	[[ -n "$cwd" ]] || return 0
	git -C "$cwd" rev-parse --show-toplevel 2>/dev/null || printf '%s\n' "$cwd"
}

worktree_removed() {
	local path pane
	path="$(field '.data.worktree.path // .data.path')"
	[[ -n "$path" ]] || return 0
	pane="$(state_get "$path" .pane_id)"
	[[ -n "$pane" ]] && { "$HERDR" plugin pane close "$pane" >/dev/null 2>&1 || true; }
	rm -f -- "$(state_file "$path")" "$(saved_file "$path")"
}

# Clears the review pane while keeping the sent history.
pane_gone() {
	local pane file
	pane="$(field .data.pane_id)"
	[[ -n "$pane" ]] || return 0
	for file in "$STATE_DIR"/reviews/*.json; do
		[[ -f "$file" ]] || continue
		[[ "$(jq -r '.pane_id // empty' "$file")" == "$pane" ]] || continue
		state_update "$(jq -r .worktree "$file")" 'del(.pane_id)'
	done
}

agent_status_changed() {
	local status pane worktree label review_pane
	status="$(field .data.agent_status)"
	pane="$(field .data.pane_id)"
	[[ " ${ON_STATES[*]} " == *" $status "* ]] || return 0

	worktree="$(worktree_for_pane "$pane")"
	[[ -n "$worktree" ]] ||
		fail "An agent in pane $pane reached \"$status\", but \`herdr agent list\` reported no worktree for that pane, so no review was prepared."

	# Remember which agent owns the worktree, so send-review works from any pane.
	state_update "$worktree" '.agent_pane_id = $p | if $a != "" then .agent_name = $a else . end' \
		--arg p "$pane" --arg a "$(field .data.agent)"
	[[ "$AUTO_OPEN" == "1" ]] || return 0

	resolve_target "$worktree" "$DEFAULT_TARGET"
	[[ -n "$TARGET_WARNING" ]] && notify "$TARGET_WARNING"
	label="$(describe_target "$TARGET_MODE" "$TARGET_REF")"
	state_update "$worktree" '.mode = $m | .ref = "" | .label = $l' --arg m "$TARGET_MODE" --arg l "$label"

	review_pane="$(state_get "$worktree" .pane_id)"
	if [[ "$REUSE_PANE" == "1" && -n "$review_pane" ]]; then
		if reload_review "$worktree" "$TARGET_MODE" "$TARGET_REF"; then
			report_metadata "$worktree"
			return 0
		fi
		# A stale pane id must not prevent a fresh open.
		state_update "$worktree" 'del(.pane_id)'
	fi

	review_pane="$(open_review_pane "$worktree" "$TARGET_MODE" "$TARGET_REF" "$pane")"
	[[ -n "$review_pane" ]] ||
		fail "An agent finished in $worktree, but the review pane could not be opened: herdr returned no pane id."
	state_update "$worktree" '.pane_id = $p' --arg p "$review_pane"
	report_metadata "$worktree"
}

# Manifest names use dots; payload types use underscores.
type="$(field '.data.type // .event')"
type="${type:-${HERDR_PLUGIN_EVENT:-}}"
case "${type//./_}" in
worktree_removed) worktree_removed ;;
pane_exited | pane_closed) pane_gone ;;
pane_agent_status_changed) agent_status_changed ;;
esac

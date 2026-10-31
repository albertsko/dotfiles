#!/usr/bin/env bash
# shellcheck disable=SC2016 # jq filters use $variables
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
# shellcheck source=../lib/common.sh
source "$SCRIPT_DIR/../lib/common.sh"

# Opens a review, or re-points the open review pane of this worktree.
review() {
	local mode="$1" url ref="" label pane agent agent_pane
	resolve_worktree

	# A GitHub commit link routed through the link handler names the commit to show.
	url="${HERDR_PLUGIN_CLICKED_URL:-$(ctx .clicked_url)}"
	if [[ "$mode" == "commit" && "$url" =~ ^https://github\.com/[^/]+/[^/]+/(pull|commit)/([A-Za-z0-9]+)/?$ ]]; then
		ref="${BASH_REMATCH[2]}"
		if [[ "${BASH_REMATCH[1]}" == "pull" ]]; then
			ref=""
			notify "hunk: GitHub pull request links aren't supported; reviewing the most recent commit instead."
		fi
	fi

	resolve_target "$WORKTREE" "$mode" "$ref"
	[[ -n "$TARGET_WARNING" ]] && notify "$TARGET_WARNING"
	# hunk would print this failure into a pane that herdr closes at once.
	[[ -z "$ref" ]] || commit_exists "$WORKTREE" "$ref" ||
		fail "Could not resolve $ref in $WORKTREE. Fetch the commit, then try the link again."

	label="$(describe_target "$TARGET_MODE" "$TARGET_REF")"
	pane="$(state_get "$WORKTREE" .pane_id)"

	if [[ "$REUSE_PANE" == "1" && -n "$pane" ]]; then
		if reload_review "$WORKTREE" "$TARGET_MODE" "$TARGET_REF"; then
			state_update "$WORKTREE" '.mode = $m | .ref = $r | .label = $l' \
				--arg m "$TARGET_MODE" --arg r "$ref" --arg l "$label"
			report_metadata "$WORKTREE"
			[[ "$FOCUS" == "1" ]] && { "$HERDR" plugin pane focus "$pane" >/dev/null 2>&1 || true; }
			return 0
		fi
		# The pane may be gone. Keep the sent history and open a new pane.
		state_update "$WORKTREE" 'del(.pane_id)'
		notify "Could not reuse the open review pane; opening a new one. $(hunk_error_message)"
	fi

	agent="$(ctx .focused_pane_agent)"
	agent_pane="$(context_agent_pane)"
	state_update "$WORKTREE" '
		.mode = $m | .ref = $r | .label = $l
		| if $a != "" then .agent_name = $a | .agent_pane_id = $ap else . end' \
		--arg m "$TARGET_MODE" --arg r "$ref" --arg l "$label" --arg a "$agent" --arg ap "$agent_pane"

	pane="$(open_review_pane "$WORKTREE" "$TARGET_MODE" "$TARGET_REF" "" "$FOCUS")"
	[[ -n "$pane" ]] ||
		fail "Could not open the hunk review pane for $WORKTREE: herdr returned no pane id. Check \`herdr plugin list\` and \`herdr plugin log list\`."
	state_update "$WORKTREE" '.pane_id = $p' --arg p "$pane"
	report_metadata "$WORKTREE"
}

# Sends unsent user comments, live and saved, to the agent that owns this worktree.
send_review() {
	local saved live='[]' unsent count agent target label text ids id
	resolve_worktree
	saved="$(load_saved "$WORKTREE")"

	if list_user_comments "$WORKTREE"; then
		live="$COMMENTS"
	elif ! hunk_no_session || [[ "$saved" == "[]" ]]; then
		fail "$(hunk_error_message)"
	fi

	unsent="$(unsent_comments "$saved" "$live" "$(sent_ids "$WORKTREE")")"
	count="$(jq length <<<"$unsent")"
	if [[ "$count" == "0" ]]; then
		notify "No new review comments to send."
		return 0
	fi

	agent="$(ctx .focused_pane_agent)"
	target="$(context_agent_pane)"
	[[ -n "$target" ]] || target="$(state_get "$WORKTREE" .agent_pane_id)"
	label="${agent:-$(state_get "$WORKTREE" .agent_name)}"
	[[ -n "$target" ]] || fail "No agent is associated with this worktree; comments kept."

	text="$(format_review "$unsent" "$WORKTREE" "$label")"
	"$HERDR" agent prompt "$target" "$text" >/dev/null 2>&1 ||
		fail "Could not prompt agent \"${label:-$target}\"; comments kept."

	# Record delivery before cleanup so a removal failure cannot cause a duplicate prompt.
	ids="$(jq -c 'map(.noteId)' <<<"$unsent")"
	state_update "$WORKTREE" '.sent = ((.sent // []) + $ids | unique)' --argjson ids "$ids"
	save_comments "$WORKTREE" "$(jq -c --argjson ids "$ids" 'map(select(.noteId | IN($ids[]) | not))' <<<"$saved")"

	if [[ "$CLEAR_AFTER_SEND" == "1" ]]; then
		while IFS= read -r id; do
			hunk_run session comment rm --repo "$WORKTREE" "$id" --json ||
				notify "Sent comment $id to ${label:-$target}, but could not remove it from hunk; it will stay visible."
		done < <(jq -r --argjson live "$live" '.[].noteId | select(IN($live[].noteId))' <<<"$unsent")
	fi

	notify "Sent $count comment(s) to ${label:-$target}."
	report_metadata "$WORKTREE"
}

# Reloads the displayed mode; a branch range is resolved again.
reload() {
	local mode ref
	resolve_worktree
	mode="$(state_get "$WORKTREE" .mode)"
	ref="$(state_get "$WORKTREE" .ref)"

	resolve_target "$WORKTREE" "$mode" "$ref"
	reload_review "$WORKTREE" "$TARGET_MODE" "$TARGET_REF" ||
		fail "Could not reload the review. $(hunk_error_message)"

	state_update "$WORKTREE" '.mode = $m | .ref = $r | .label = $l' \
		--arg m "$TARGET_MODE" --arg r "$ref" --arg l "$(describe_target "$TARGET_MODE" "$TARGET_REF")"
	[[ -n "$TARGET_WARNING" ]] && notify "$TARGET_WARNING"
	report_metadata "$WORKTREE"
}

close_review() {
	local pane
	resolve_worktree
	pane="$(state_get "$WORKTREE" .pane_id)"
	if [[ -z "$pane" ]]; then
		notify "No review pane is open for this worktree."
		return 0
	fi
	"$HERDR" plugin pane close "$pane" >/dev/null 2>&1 ||
		fail "Could not close the review pane $pane. \`herdr plugin log list\` has the refusal."
}

# Prints setup snippets for VCSs whose config is edited by hand.
manual_pager_setup() {
	command -v jj >/dev/null &&
		printf 'Jujutsu: run `jj config edit --user` and add:\n[ui]\npager = ["hunk", "pager"]\ndiff-formatter = ":git"\n\n'
	command -v sl >/dev/null &&
		printf 'Sapling: run `sl config -u` and add:\n[pager]\npager = hunk pager\n\n'
	return 0
}

install_pager() {
	local values current message
	command -v "$HUNK" >/dev/null ||
		fail "hunk is not on your PATH, so git's core.pager was left alone. Install hunk, then run this action again."

	readarray -t values < <(git config --global --get-all core.pager || true)
	((${#values[@]} <= 1)) ||
		fail "git's core.pager has multiple values, so it was left alone. Run \`git config --global --replace-all core.pager '$PAGER_VALUE'\` yourself."
	current="${values[0]:-}"

	if [[ "$current" == "$PAGER_VALUE" ]]; then
		message="hunk is already your git pager."
	else
		git config --global core.pager "$PAGER_VALUE"
		message="hunk is now your git pager."
		[[ -n "$current" ]] &&
			message="git's core.pager was \`$current\`; hunk is now your git pager. Restore it with \`git config --global core.pager '$current'\`."
	fi
	notify "$message" "$(manual_pager_setup)"
}

uninstall_pager() {
	local values
	readarray -t values < <(git config --global --get-all core.pager || true)
	((${#values[@]} <= 1)) ||
		fail "git's core.pager has multiple values, so it was left alone."

	if [[ -z "${values[0]:-}" ]]; then
		notify "git's core.pager is not set; there was nothing to remove."
		return 0
	fi
	[[ "${values[0]}" == "$PAGER_VALUE" ]] ||
		fail "git's core.pager is \`${values[0]}\`, which this plugin did not write, so it was left alone."

	git config --global --unset core.pager
	notify "hunk is no longer your git pager."
}

case "${1:-}" in
review) review "$DEFAULT_TARGET" ;;
review:staged) review staged ;;
review:branch) review branch ;;
review:commit) review commit ;;
send-review) send_review ;;
reload) reload ;;
close-review) close_review ;;
install-pager) install_pager ;;
uninstall-pager) uninstall_pager ;;
*)
	printf 'Usage: %s <action>\n' "$(basename -- "$0")" >&2
	exit 2
	;;
esac

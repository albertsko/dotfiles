# shellcheck shell=bash disable=SC2034 # settings and results are read by the sourcing scripts
# Shared settings and helpers for the hunkdiff plugin. Sourced by the scripts in bin/.

readonly PLUGIN_ID="local.hunkdiff"
readonly HERDR="${HERDR_BIN_PATH:-herdr}"
readonly HUNK="hunk"
readonly STATE_DIR="${HERDR_PLUGIN_STATE_DIR:-$HOME/.local/state/herdr-hunkdiff}"

# Settings. Edit these constants instead of a config file.
readonly AUTO_OPEN=0         # open or refresh a review when an agent reaches ON_STATES
readonly ON_STATES=(idle)    # idle | working | blocked | unknown
readonly REUSE_PANE=1        # reload the open review instead of opening another pane
readonly DEFAULT_TARGET=auto # auto | working | staged | branch
readonly BASE_REF=""         # branch reviews compare against this ref; empty detects one
readonly WATCH=0             # pass --watch to hunk
readonly EXCLUDE_UNTRACKED=0 # hide untracked files in working, staged, and branch reviews
readonly PLACEMENT=split     # overlay | split | tab | zoomed
readonly FOCUS=0             # focus the review pane after a review action
readonly CLEAR_AFTER_SEND=1  # remove delivered comments from hunk
readonly EXPERIMENTAL=0      # pass --experimental to hunk
readonly EXTRA_ARGS=()       # appended to every hunk launch
readonly PAGER_VALUE="hunk pager"
readonly PROMPT_TEMPLATE="Human-authored inline review comments on your changes in {worktree}:

{comments}

Address each comment and verify the resulting changes. If a comment is unclear or requires a decision, ask a focused clarification question and continue with any unaffected comments. Then summarize what you changed and explain anything you did not implement."

# Herdr

notify() {
	local args=(notification show "$1")
	[[ -n "${2:-}" ]] && args+=(--body "$2")
	"$HERDR" "${args[@]}" >/dev/null 2>&1 || true
}

# Herdr discards the pane or command output, so failures also go to the notification.
fail() {
	printf 'hunkdiff: %s\n' "$1" >&2
	notify "$1"
	exit 1
}

# Prints one field of HERDR_PLUGIN_CONTEXT_JSON, or nothing.
ctx() {
	jq -r "$1 // empty" <<<"${HERDR_PLUGIN_CONTEXT_JSON:-}" 2>/dev/null || true
}

# Sets WORKTREE to the git root of the focused pane, so one repository has one review.
resolve_worktree() {
	local dir
	dir="$(ctx '.focused_pane_cwd // .workspace_cwd')"
	if [[ -z "$dir" ]]; then
		dir="$PWD"
		notify "No worktree resolved from herdr context; using $dir instead."
	fi
	WORKTREE="$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)" || WORKTREE="$dir"
}

# Prints the focused pane only when herdr reports that it runs an agent.
context_agent_pane() {
	[[ -n "$(ctx .focused_pane_agent)" ]] || return 0
	local pane
	pane="$(ctx .focused_pane_id)"
	printf '%s\n' "${pane:-${HERDR_PANE_ID:-}}"
}

# Prints the new pane id, or nothing when herdr refuses.
open_review_pane() {
	local worktree="$1" mode="$2" ref="$3" target_pane="${4:-}" focus="${5:-0}"
	local args=(
		plugin pane open --plugin "$PLUGIN_ID" --entrypoint review
		--cwd "$worktree" --placement "$PLACEMENT"
		--env "HUNKDIFF_MODE=$mode" --env "HUNKDIFF_REF=$ref"
	)
	[[ -n "$target_pane" ]] && args+=(--target-pane "$target_pane")
	[[ "$focus" == "1" ]] && args+=(--focus)
	"$HERDR" "${args[@]}" 2>/dev/null | jq -r '.result.plugin_pane.pane.pane_id // empty' 2>/dev/null || true
}

# State: one JSON file per worktree with agent, pane, displayed target, and sent comment ids.

state_key() {
	printf '%s' "$1" | git hash-object --stdin | cut -c1-12
}

state_file() {
	printf '%s/reviews/%s.json\n' "$STATE_DIR" "$(state_key "$1")"
}

saved_file() {
	printf '%s/saved-comments/%s.json\n' "$STATE_DIR" "$(state_key "$1")"
}

state_get() {
	local file
	file="$(state_file "$1")"
	[[ -f "$file" ]] || return 0
	jq -r "$2 // empty" "$file" 2>/dev/null || true
}

# Usage: state_update WORKTREE JQ_FILTER [JQ_ARGS...]. Writes atomically; there is no lock.
state_update() {
	local worktree="$1" filter="$2" file current='{}'
	shift 2
	file="$(state_file "$worktree")"
	mkdir -p -- "$(dirname -- "$file")"
	[[ -f "$file" ]] && current="$(<"$file")"
	jq "$@" --arg wt "$worktree" ".worktree = \$wt | $filter" <<<"$current" >"$file.$$.tmp"
	mv -f -- "$file.$$.tmp" "$file"
}

sent_ids() {
	local ids
	ids="$(state_get "$1" '(.sent // []) | tojson')"
	printf '%s\n' "${ids:-[]}"
}

# Saved comments: hunk keeps comments in memory only, so the pane snapshots unsent ones here.

load_saved() {
	local file comments=""
	file="$(saved_file "$1")"
	[[ -f "$file" ]] && comments="$(jq -c '.comments // []' "$file" 2>/dev/null || true)"
	printf '%s\n' "${comments:-[]}"
}

save_comments() {
	local file
	file="$(saved_file "$1")"
	if [[ "$(jq length <<<"$2")" == "0" ]]; then
		rm -f -- "$file"
		return 0
	fi
	mkdir -p -- "$(dirname -- "$file")"
	jq '{comments: .}' <<<"$2" >"$file.$$.tmp"
	mv -f -- "$file.$$.tmp" "$file"
}

# Usage: unsent_comments SAVED LIVE SENT. Live comments replace saved ones with the same id.
unsent_comments() {
	jq -cn --argjson saved "$1" --argjson live "$2" --argjson sent "$3" '
		($live | map(.noteId)) as $ids
		| [$saved[] | select(.noteId | IN($ids[]) | not)] + $live
		| map(select(.noteId | IN($sent[]) | not))'
}

# Usage: format_review COMMENTS WORKTREE AGENT. One gsub pass keeps placeholders in comments intact.
format_review() {
	jq -rn --argjson c "$1" --arg wt "$2" --arg agent "${3:-agent}" --arg tpl "$PROMPT_TEMPLATE" '
		($c | map(
			((.newRange // [])[0] // (.oldRange // [])[0]) as $at
			| "- \(.filePath)\(if $at == null then "" else ":\($at)" end) — \(.body)"
		) | join("\n")) as $comments
		| {worktree: $wt, comments: $comments, count: ($c | length | tostring), agent: $agent} as $v
		| $tpl | gsub("\\{(?<k>worktree|comments|count|agent)\\}"; $v[.k])'
}

# Hunk

# Runs hunk and sets HUNK_OUT and HUNK_ERR.
hunk_run() {
	local err_file status=0
	err_file="$(mktemp)"
	HUNK_OUT="$("$HUNK" "$@" 2>"$err_file")" || status=$?
	HUNK_ERR="$(<"$err_file")"
	rm -f -- "$err_file"
	return "$status"
}

hunk_no_session() {
	# hunk 0.23 says "No active Hunk sessions"; 0.24 says "No active session matches repoRoot ...".
	grep -qiE 'No active (Hunk )?sessions?' <<<"$HUNK_ERR"
}

hunk_error_message() {
	if hunk_no_session; then
		echo "No active hunk session. If hunk is visibly running, loopback (127.0.0.1:47657) may be blocked by an agent sandbox; set HUNK_MCP_PORT or relax the sandbox."
		return 0
	fi
	printf '%s\n' "${HUNK_ERR:-hunk failed.}"
}

# Sets COMMENTS to the live session's user comments. Rejects comments without a stable id.
list_user_comments() {
	hunk_run session comment list --repo "$1" --type user --json || return 1
	COMMENTS="$(jq -c '
		(.comments // [])
		| if type == "array" and all(.[];
			type == "object" and (.noteId | type) == "string" and .noteId != ""
			and (.filePath | type) == "string" and (.body | type) == "string")
		then . else error("invalid") end' <<<"$HUNK_OUT" 2>/dev/null)" && return 0
	HUNK_ERR="hunk returned an invalid comment list; comments were not sent."
	return 1
}

# Targets

# Sets TARGET_ARGS to the hunk subcommand for a mode, without launch-only flags.
target_args() {
	local mode="$1" ref="$2"
	case "$mode" in
	commit) TARGET_ARGS=(show) ;;
	staged) TARGET_ARGS=(diff --staged) ;;
	*) TARGET_ARGS=(diff) ;;
	esac
	[[ -n "$ref" && "$mode" =~ ^(commit|branch)$ ]] && TARGET_ARGS+=("$ref")
	[[ "$EXCLUDE_UNTRACKED" == "1" && "$mode" =~ ^(working|staged|branch)$ ]] && TARGET_ARGS+=(--exclude-untracked)
	return 0
}

describe_target() {
	local mode="$1" ref="$2"
	case "$mode" in
	staged) echo "staged" ;;
	branch) printf '%s\n' "${ref:-branch}" ;;
	commit) printf '%s\n' "${ref:+commit }${ref:-last commit}" ;;
	*) echo "working tree" ;;
	esac
}

commit_exists() {
	git -C "$1" rev-parse --verify --quiet "$2^{commit}" >/dev/null 2>&1
}

# Sets BASE to a base other than the current branch: upstream, origin/HEAD, then main/master/trunk.
detect_base() {
	local worktree="$1" current candidate name
	BASE=""
	current="$(git -C "$worktree" symbolic-ref --quiet --short HEAD 2>/dev/null)" || current=""

	for candidate in \
		"$(git -C "$worktree" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)" \
		"$(git -C "$worktree" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)"; do
		[[ -n "$candidate" ]] || continue
		# Remote names may contain slashes, so reject any candidate ending in the current branch.
		[[ -n "$current" && ("$candidate" == "$current" || "$candidate" == */"$current") ]] && continue
		BASE="$candidate"
		return 0
	done

	for name in main master trunk; do
		git -C "$worktree" rev-parse --verify --quiet "$name" >/dev/null 2>&1 || continue
		BASE="$name"
		return 0
	done
}

# Sets BASE, validating BASE_REF before it becomes a revision range.
find_base() {
	local worktree="$1"
	if [[ -z "$BASE_REF" ]]; then
		detect_base "$worktree"
		return 0
	fi
	BASE="$BASE_REF"
	commit_exists "$worktree" "$BASE_REF" && return 0

	detect_base "$worktree"
	TARGET_WARNING+="Configured base \"$BASE_REF\" does not exist in this repository; ${BASE:+comparing against $BASE instead.}${BASE:-no base branch resolved.} "
}

# Usage: resolve_target WORKTREE MODE [REF]. Sets TARGET_MODE, TARGET_REF, and TARGET_WARNING.
resolve_target() {
	local worktree="$1" mode="${2:-$DEFAULT_TARGET}" ref="${3:-}" untracked=normal count
	TARGET_MODE="$mode"
	TARGET_REF="$ref"
	TARGET_WARNING=""

	[[ "$mode" =~ ^(working|staged|commit)$ ]] && return 0

	if [[ "$mode" == "auto" ]]; then
		[[ "$EXCLUDE_UNTRACKED" == "1" ]] && untracked=no
		TARGET_MODE=working
		[[ -n "$(git -C "$worktree" status --porcelain --untracked-files="$untracked" 2>/dev/null)" ]] && return 0
	fi

	find_base "$worktree"
	if [[ -z "$BASE" ]]; then
		TARGET_MODE=working
		TARGET_WARNING+="No base branch resolved; reviewing the working tree instead."
		return 0
	fi

	# Auto mode shows the branch only when it is ahead; an explicit branch review always shows it.
	count="$(git -C "$worktree" rev-list --count "$BASE..HEAD" 2>/dev/null)" || count=0
	[[ "$mode" == "auto" && "$count" == "0" ]] && return 0
	TARGET_MODE=branch
	TARGET_REF="$BASE...HEAD"
}

reload_review() {
	local worktree="$1" mode="$2" ref="$3"
	target_args "$mode" "$ref"
	hunk_run session reload --repo "$worktree" --json -- "${TARGET_ARGS[@]}"
}

# Pane title and unsent count are cosmetic, so failures are ignored.
report_metadata() {
	local worktree="$1" pane label title agent=hunk count=0
	pane="$(state_get "$worktree" .pane_id)"
	[[ -n "$pane" ]] || return 0

	label="$(state_get "$worktree" .label)"
	title="Review: $(basename -- "$worktree")${label:+ — $label}"
	list_user_comments "$worktree" && count="$(unsent_comments '[]' "$COMMENTS" "$(sent_ids "$worktree")" | jq length)"
	[[ "$count" != "0" ]] && agent="hunk ($count unsent)"

	"$HERDR" pane report-metadata "$pane" --source "plugin:$PLUGIN_ID" --title "$title" --display-agent "$agent" >/dev/null 2>&1 || true
}

#!/usr/bin/env bash
set -euo pipefail

MODEL="${CODEX_TASK_MODEL:-gpt-5.6-sol}"
EFFORT="${CODEX_TASK_EFFORT:-medium}"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

while :; do
	case "${1-}" in
	--model)
		[[ ${2-} ]] || die '"--model" requires a non-empty argument'
		MODEL=$2
		shift
		;;
	--model=?*) MODEL=${1#*=} ;;
	--model=) die '"--model" requires a non-empty argument' ;;
	--effort)
		[[ ${2-} ]] || die '"--effort" requires a non-empty argument'
		EFFORT=$2
		shift
		;;
	--effort=?*) EFFORT=${1#*=} ;;
	--effort=) die '"--effort" requires a non-empty argument' ;;
	--)
		shift
		break
		;;
	-?*) die "unknown option: $1" ;;
	*) break ;;
	esac
	shift
done

[[ $1 ]] || die 'prompt must be non-empty'

prompt="$1

Do not include your reasoning or step-by-step narration in messages. Reply with the final result only."

codex exec \
	--model="$MODEL" \
	-c model_reasoning_effort="$EFFORT" \
	--ephemeral \
	--skip-git-repo-check \
	--dangerously-bypass-approvals-and-sandbox \
	--json "$prompt" </dev/null |
	jq -r '
		if .type == "item.completed" and .item.type == "agent_message" then .item.text
		elif .type == "error" or .type == "turn.failed" then tojson | halt_error(1)
		else empty
		end'

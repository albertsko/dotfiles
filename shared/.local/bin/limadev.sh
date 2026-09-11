#!/usr/bin/env bash
set -euo pipefail

readonly INSTANCE_NAME="limadev"
readonly DOCKER_CONTEXT="lima-limadev"
readonly CREATE_TIMEOUT="30m"
readonly REPO_URL="https://github.com/albertsko/dotfiles.git"
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$SCRIPT_DIR/../../..")}"
readonly DOTFILES_HOME
readonly CONFIG_PATH="$DOTFILES_HOME/lima/.config/lima/limadev.yml"
readonly DOTFILES_REF="${LIMADEV_DOTFILES_REF:-main}"
RECREATE=0

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

usage() {
	printf 'Usage: %s [--recreate] [--] [command...]\n' "$(basename -- "$0")"
}

lima_instance_exists() {
	local instance_names
	local name

	instance_names="$(limactl list --quiet)" || die 'failed to inspect Lima instances'
	while IFS= read -r name; do
		[[ "$name" == "$INSTANCE_NAME" ]] || continue
		return 0
	done <<<"$instance_names"

	return 1
}

reconcile_docker_context() {
	local docker_host=$1
	local context_host

	if ! context_host="$(docker context inspect "$DOCKER_CONTEXT" --format '{{.Endpoints.docker.Host}}' 2>/dev/null)"; then
		docker context create "$DOCKER_CONTEXT" --docker "host=$docker_host" >/dev/null || die 'failed to create the Docker context'
		return
	fi

	[[ "$context_host" == "$docker_host" ]] && return
	docker context update "$DOCKER_CONTEXT" --docker "host=$docker_host" >/dev/null || die 'failed to update the Docker context'
}

while :; do
	case "${1-}" in
	--recreate)
		RECREATE=1
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	--)
		shift
		break
		;;
	-?*) die "unknown option: $1" ;;
	*) break ;;
	esac
done

[[ "$(uname -s)" == "Darwin" ]] || die 'this script requires macOS'
[[ "$(uname -m)" == "arm64" ]] || die 'this script requires Apple silicon'
[[ -f "$CONFIG_PATH" ]] || die "Lima configuration is missing: $CONFIG_PATH"
[[ -n "$DOTFILES_REF" ]] || die 'LIMADEV_DOTFILES_REF must not be empty'
command -v limactl >/dev/null 2>&1 || die 'limactl is not installed'
command -v docker >/dev/null 2>&1 || die 'the Docker CLI is not installed'
command -v gh >/dev/null 2>&1 || die 'gh is not installed'
command -v git >/dev/null 2>&1 || die 'git is not installed'
[[ -n "${SSH_AUTH_SOCK:-}" && -S "$SSH_AUTH_SOCK" ]] || die 'an SSH agent is not available'
ssh-add -l >/dev/null 2>&1 || die 'the SSH agent has no available identities'

gh_token="${GH_TOKEN:-}"
if [[ -z "$gh_token" ]]; then
	gh_token="$(gh auth token --hostname github.com)" || die 'GitHub CLI authentication is unavailable; run gh auth login -h github.com'
fi

instance_exists=0
lima_instance_exists && instance_exists=1

if ((instance_exists == 0 || RECREATE == 1)); then
	limactl template validate --fill "$CONFIG_PATH" >/dev/null || die 'the Lima configuration is invalid'
	git ls-remote --exit-code "$REPO_URL" "refs/heads/$DOTFILES_REF" "refs/tags/$DOTFILES_REF" >/dev/null 2>&1 ||
		die "dotfiles ref does not exist as a branch or tag: $DOTFILES_REF"
fi

if ((RECREATE == 1 && instance_exists == 1)); then
	limactl delete --force "$INSTANCE_NAME" || die "failed to delete Lima instance: $INSTANCE_NAME"
	instance_exists=0
fi

if ((instance_exists == 0)); then
	limactl start \
		--name="$INSTANCE_NAME" \
		--param="DOTFILES_REF=$DOTFILES_REF" \
		--progress \
		--timeout="$CREATE_TIMEOUT" \
		--tty=false \
		"$CONFIG_PATH" || die "failed to create Lima instance: $INSTANCE_NAME"
else
	instance_ref="$(limactl list "$INSTANCE_NAME" --format '{{.Param.DOTFILES_REF}}')" || die 'failed to determine the instance dotfiles ref'
	[[ "$instance_ref" == "$DOTFILES_REF" ]] || die "instance uses dotfiles ref '$instance_ref', not '$DOTFILES_REF'; rerun with --recreate"
	limactl start "$INSTANCE_NAME" || die "failed to start Lima instance: $INSTANCE_NAME"
fi

docker_host="$(limactl list "$INSTANCE_NAME" --format 'unix://{{.Dir}}/sock/docker.sock')" || die 'failed to determine the Docker socket path'
reconcile_docker_context "$docker_host"

exec env \
	"GH_TOKEN=$gh_token" \
	LIMA_SHELLENV_BLOCK='*' \
	LIMA_SHELLENV_ALLOW='GH_TOKEN' \
	limactl shell --preserve-env "$INSTANCE_NAME" -- "$@" || die "failed to enter Lima instance: $INSTANCE_NAME"

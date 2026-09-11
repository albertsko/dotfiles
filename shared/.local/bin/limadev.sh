#!/usr/bin/env bash
set -euo pipefail

readonly INSTANCE_NAME="limadev"
readonly DOCKER_CONTEXT="lima-limadev"
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$SCRIPT_DIR/../../..")}"
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
[[ -n "${SSH_AUTH_SOCK:-}" && -S "$SSH_AUTH_SOCK" ]] || die 'an SSH agent is not available'
ssh-add -l >/dev/null 2>&1 || die 'the SSH agent has no available identities'

gh_token="${GH_TOKEN:-}"
if [[ -z "$gh_token" ]]; then
	gh_token="$(gh auth token --hostname github.com)" || die 'GitHub CLI authentication is unavailable; run gh auth login -h github.com'
fi

instance_names="$(limactl list --quiet)" || die 'failed to inspect Lima instances'
instance=""
while IFS= read -r name; do
	[[ "$name" == "$INSTANCE_NAME" ]] && instance="$name"
done <<<"$instance_names"

if [[ "$RECREATE" == "1" && -n "$instance" ]]; then
	limactl delete --force "$INSTANCE_NAME" || die "failed to delete Lima instance: $INSTANCE_NAME"
	instance=""
fi

if [[ -z "$instance" ]]; then
	limactl start \
		--name="$INSTANCE_NAME" \
		--param="DOTFILES_REF=$DOTFILES_REF" \
		--progress \
		--tty=false \
		"$CONFIG_PATH" || die "failed to create Lima instance: $INSTANCE_NAME"
else
	limactl start "$INSTANCE_NAME" || die "failed to start Lima instance: $INSTANCE_NAME"
fi

docker_host="$(limactl list "$INSTANCE_NAME" --format 'unix://{{.Dir}}/sock/docker.sock')" || die 'failed to determine the Docker socket path'
if docker context inspect "$DOCKER_CONTEXT" >/dev/null 2>&1; then
	docker context update "$DOCKER_CONTEXT" --docker "host=$docker_host" >/dev/null || die 'failed to update the Docker context'
else
	docker context create "$DOCKER_CONTEXT" --docker "host=$docker_host" >/dev/null || die 'failed to create the Docker context'
fi

exec env \
	"GH_TOKEN=$gh_token" \
	LIMA_SHELLENV_BLOCK='*' \
	LIMA_SHELLENV_ALLOW='GH_TOKEN' \
	limactl shell --preserve-env "$INSTANCE_NAME" -- "$@"

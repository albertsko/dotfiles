#!/usr/bin/env bash
set -euo pipefail

readonly INSTANCE_NAME="limadev"
readonly DOCKER_CONTEXT="limadev"
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$SCRIPT_DIR/../../..")}"
readonly DOTFILES_HOME
readonly CONFIG_PATH="$DOTFILES_HOME/lima/.config/lima/limadev.yml"
readonly DOTFILES_REF="${LIMADEV_DOTFILES_REF:-$(git -C "$DOTFILES_HOME" branch --show-current)}"

[[ "${1:-}" != "--recreate" ]] || {
	limactl delete --force "$INSTANCE_NAME" >/dev/null 2>&1 || true
	shift
}

limactl list "$INSTANCE_NAME" --format '{{.Name}}' >/dev/null 2>&1 ||
	limactl start \
		--name="$INSTANCE_NAME" \
		--param="DOTFILES_REF=$DOTFILES_REF" \
		--progress \
		--timeout=30m \
		--tty=false \
		"$CONFIG_PATH"

docker_host="$(limactl list "$INSTANCE_NAME" --format 'unix://{{.Dir}}/sock/docker.sock')"
context_action=update
docker context inspect "$DOCKER_CONTEXT" >/dev/null 2>&1 || context_action=create
docker context "$context_action" "$DOCKER_CONTEXT" --docker "host=$docker_host" >/dev/null

gh_token="${GH_TOKEN:-$(gh auth token --hostname github.com)}"
exec env \
	"GH_TOKEN=$gh_token" \
	LIMA_SHELLENV_BLOCK='*' \
	LIMA_SHELLENV_ALLOW=GH_TOKEN \
	limactl shell --start --preserve-env "$INSTANCE_NAME" -- "$@"

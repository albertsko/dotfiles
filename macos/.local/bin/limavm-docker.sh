#!/usr/bin/env bash
set -euo pipefail

readonly INSTANCE_NAME="docker"
readonly DOCKER_CONTEXT="lima-docker"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == "Darwin" ]] || die 'this script requires macOS'
[[ "$(uname -m)" == "arm64" ]] || die 'this script requires Apple silicon'
command -v limactl >/dev/null 2>&1 || die 'limactl is not installed'
command -v docker >/dev/null 2>&1 || die 'the Docker CLI is not installed'

limactl start \
	--name="$INSTANCE_NAME" \
	--vm-type=vz \
	--cpus=4 \
	--memory=2 \
	--disk=100 \
	--mount-writable \
	--rosetta \
	--tty=false \
	template:docker-rootful || die "failed to start Lima instance: $INSTANCE_NAME"

docker_host="unix://${HOME}/.lima/$INSTANCE_NAME/sock/docker.sock"
if ! context_host="$(docker context inspect "$DOCKER_CONTEXT" --format '{{.Endpoints.docker.Host}}' 2>/dev/null)"; then
	docker context create "$DOCKER_CONTEXT" --docker "host=$docker_host" >/dev/null || die "failed to create Docker context: $DOCKER_CONTEXT"
elif [[ "$context_host" != "$docker_host" ]]; then
	docker context update "$DOCKER_CONTEXT" --docker "host=$docker_host" >/dev/null || die "failed to update Docker context: $DOCKER_CONTEXT"
fi

docker context use "$DOCKER_CONTEXT" >/dev/null || die "failed to select Docker context: $DOCKER_CONTEXT"

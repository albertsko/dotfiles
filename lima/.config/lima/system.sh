#!/usr/bin/env bash
set -euo pipefail

readonly MARKER="/var/lib/limadev-system.done"
readonly DOCKER_KEYRING="/etc/apt/keyrings/docker.asc"
readonly DOCKER_SOURCE="/etc/apt/sources.list.d/docker.sources"
readonly DOCKER_PACKAGES=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
readonly SYSTEM_PACKAGES=(build-essential ca-certificates curl file git procps)

[[ -f "$MARKER" ]] && exit 0

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install --yes "${SYSTEM_PACKAGES[@]}"

install -m 0755 -d "$(dirname -- "$DOCKER_KEYRING")"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o "$DOCKER_KEYRING"
chmod a+r "$DOCKER_KEYRING"

. /etc/os-release
printf '%s\n' \
	'Types: deb' \
	'URIs: https://download.docker.com/linux/ubuntu' \
	"Suites: ${UBUNTU_CODENAME:-$VERSION_CODENAME}" \
	'Components: stable' \
	"Architectures: $(dpkg --print-architecture)" \
	"Signed-By: $DOCKER_KEYRING" >"$DOCKER_SOURCE"

apt-get update
apt-get install --yes "${DOCKER_PACKAGES[@]}"

systemctl daemon-reload
systemctl enable docker.socket docker.service
systemctl restart docker.socket docker.service

touch "$MARKER"

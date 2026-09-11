#!/usr/bin/env bash
set -euo pipefail

readonly DOCKER_KEYRING="/etc/apt/keyrings/docker.asc"
readonly DOCKER_SOURCE="/etc/apt/sources.list.d/docker.sources"
readonly CONFLICTING_PACKAGES=(docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc)
readonly DOCKER_PACKAGES=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
readonly SYSTEM_PACKAGES=(build-essential ca-certificates curl file git procps)

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == "Linux" ]] || die 'this script requires Linux'
((EUID == 0)) || die 'this script must run as root'
command -v apt-get >/dev/null 2>&1 || die 'apt-get is not available'

export DEBIAN_FRONTEND=noninteractive

for package in "${CONFLICTING_PACKAGES[@]}"; do
	status="$(dpkg-query --show --showformat='${db:Status-Abbrev}' "$package" 2>/dev/null || true)"
	[[ "$status" == ii* ]] && apt-get remove --yes "$package"
done

apt-get update
apt-get install --yes "${SYSTEM_PACKAGES[@]}"

install -m 0755 -d "$(dirname -- "$DOCKER_KEYRING")"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o "$DOCKER_KEYRING" || die 'failed to download the Docker signing key'
chmod a+r "$DOCKER_KEYRING"

# shellcheck source=/dev/null
. /etc/os-release
docker_codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
docker_arch="$(dpkg --print-architecture)" || die 'failed to determine the system architecture'
[[ -n "$docker_codename" ]] || die 'failed to determine the Ubuntu codename'

printf '%s\n' \
	'Types: deb' \
	'URIs: https://download.docker.com/linux/ubuntu' \
	"Suites: $docker_codename" \
	'Components: stable' \
	"Architectures: $docker_arch" \
	"Signed-By: $DOCKER_KEYRING" >"$DOCKER_SOURCE"

apt-get update
apt-get install --yes "${DOCKER_PACKAGES[@]}"
systemctl daemon-reload
systemctl enable docker.service docker.socket
systemctl restart docker.socket docker.service

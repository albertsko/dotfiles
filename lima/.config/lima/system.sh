#!/usr/bin/env bash
set -euo pipefail

readonly DOCKER_KEYRING="/etc/apt/keyrings/docker.asc"
readonly DOCKER_SOURCE="/etc/apt/sources.list.d/docker.sources"
readonly PROVISION_MARKER="/var/lib/limadev/system-v1.done"
readonly APT_OPTIONS=(--yes -o Acquire::Retries=5 -o Acquire::http::Timeout=30 -o Acquire::https::Timeout=30)
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

docker_installation_ready=1
for package in "${SYSTEM_PACKAGES[@]}" "${DOCKER_PACKAGES[@]}"; do
	status="$(dpkg-query --show --showformat='${db:Status-Abbrev}' "$package" 2>/dev/null || true)"
	if [[ "$status" != ii* ]]; then
		docker_installation_ready=0
		break
	fi
done

if [[ -f "$PROVISION_MARKER" && -s "$DOCKER_KEYRING" && -s "$DOCKER_SOURCE" && "$docker_installation_ready" == "1" ]]; then
	systemctl start docker.socket docker.service || die 'failed to start Docker'
	exit 0
fi

installed_conflicts=()
for package in "${CONFLICTING_PACKAGES[@]}"; do
	status="$(dpkg-query --show --showformat='${db:Status-Abbrev}' "$package" 2>/dev/null || true)"
	[[ "$status" == ii* ]] && installed_conflicts+=("$package")
done
if ((${#installed_conflicts[@]} > 0)); then
	apt-get "${APT_OPTIONS[@]}" remove "${installed_conflicts[@]}"
fi

rm -f -- "$DOCKER_SOURCE"
apt-get "${APT_OPTIONS[@]}" update
apt-get "${APT_OPTIONS[@]}" install "${SYSTEM_PACKAGES[@]}"

install -m 0755 -d "$(dirname -- "$DOCKER_KEYRING")"
key_tmp="$(mktemp "$(dirname -- "$DOCKER_KEYRING")/docker.asc.XXXXXX")"
source_tmp="$(mktemp "$(dirname -- "$DOCKER_SOURCE")/docker.sources.XXXXXX")"
trap 'rm -f -- "$key_tmp" "$source_tmp"' EXIT
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o "$key_tmp" || die 'failed to download the Docker signing key'
chmod 0644 "$key_tmp"
mv -f -- "$key_tmp" "$DOCKER_KEYRING"

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
	"Signed-By: $DOCKER_KEYRING" >"$source_tmp"
chmod 0644 "$source_tmp"
mv -f -- "$source_tmp" "$DOCKER_SOURCE"

apt-get "${APT_OPTIONS[@]}" update
apt-get "${APT_OPTIONS[@]}" install "${DOCKER_PACKAGES[@]}"
systemctl daemon-reload
systemctl enable docker.service docker.socket
systemctl restart docker.socket docker.service
install -m 0755 -d "$(dirname -- "$PROVISION_MARKER")"
touch "$PROVISION_MARKER"

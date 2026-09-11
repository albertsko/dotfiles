#!/usr/bin/env bash
set -euo pipefail

readonly DOCKER_KEYRING="/etc/apt/keyrings/docker.asc"
readonly DOCKER_SOURCE="/etc/apt/sources.list.d/docker.sources"
readonly PROVISION_MARKER="/var/lib/limadev/system-v1.done"
readonly UBUNTU_SOURCES="/etc/apt/sources.list.d/ubuntu.sources"
readonly APT_OPTIONS=(--yes -o Acquire::Retries=5 -o Acquire::http::Timeout=30 -o Acquire::https::Timeout=30)
readonly CONFLICTING_PACKAGES=(docker.io docker-compose docker-compose-v2 docker-doc docker-buildx podman-docker containerd runc)
readonly DOCKER_PACKAGES=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
readonly SYSTEM_PACKAGES=(build-essential ca-certificates curl file git procps)

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

package_is_installed() {
	local package=$1
	local status

	status="$(dpkg-query --show --showformat='${db:Status-Abbrev}' "$package" 2>/dev/null || true)"
	[[ "$status" == ii* ]]
}

docker_installation_is_ready() {
	local package

	[[ -f "$PROVISION_MARKER" ]] || return 1
	[[ -s "$DOCKER_KEYRING" ]] || return 1
	[[ -s "$DOCKER_SOURCE" ]] || return 1

	for package in "${SYSTEM_PACKAGES[@]}" "${DOCKER_PACKAGES[@]}"; do
		package_is_installed "$package" || return 1
	done
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == "Linux" ]] || die 'this script requires Linux'
((EUID == 0)) || die 'this script must run as root'
command -v apt-get >/dev/null 2>&1 || die 'apt-get is not available'
[[ -f "$UBUNTU_SOURCES" ]] || die "Ubuntu package sources are missing: $UBUNTU_SOURCES"

export DEBIAN_FRONTEND=noninteractive

sed -i \
	-e 's|http://archive.ubuntu.com/ubuntu|https://ports.ubuntu.com/ubuntu-ports|g' \
	-e 's|http://security.ubuntu.com/ubuntu|https://ports.ubuntu.com/ubuntu-ports|g' \
	"$UBUNTU_SOURCES" || die 'failed to configure the Ubuntu ports mirror'

if docker_installation_is_ready; then
	systemctl start docker.socket docker.service || die 'failed to start Docker'
	exit 0
fi

installed_conflicts=()
for package in "${CONFLICTING_PACKAGES[@]}"; do
	package_is_installed "$package" || continue
	installed_conflicts+=("$package")
done
if ((${#installed_conflicts[@]} > 0)); then
	apt-get "${APT_OPTIONS[@]}" remove "${installed_conflicts[@]}" || die 'failed to remove conflicting container packages'
fi

rm -f -- "$DOCKER_SOURCE" || die "failed to remove the old Docker package source: $DOCKER_SOURCE"
apt-get "${APT_OPTIONS[@]}" update || die 'failed to update Apt package metadata'
apt-get "${APT_OPTIONS[@]}" install "${SYSTEM_PACKAGES[@]}" || die 'failed to install required system packages'

install -m 0755 -d "$(dirname -- "$DOCKER_KEYRING")" || die 'failed to create the Apt keyring directory'
key_tmp="$(mktemp "$(dirname -- "$DOCKER_KEYRING")/docker.asc.XXXXXX")" || die 'failed to create a temporary Docker key file'
source_tmp="$(mktemp "$(dirname -- "$DOCKER_SOURCE")/docker.sources.XXXXXX")" || die 'failed to create a temporary Docker source file'
trap 'rm -f -- "$key_tmp" "$source_tmp"' EXIT
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o "$key_tmp" || die 'failed to download the Docker signing key'
chmod 0644 "$key_tmp" || die 'failed to set permissions on the Docker signing key'
mv -f -- "$key_tmp" "$DOCKER_KEYRING" || die 'failed to install the Docker signing key'

# shellcheck source=/dev/null
. /etc/os-release || die 'failed to load operating system metadata'
docker_codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
docker_arch="$(dpkg --print-architecture)" || die 'failed to determine the system architecture'
[[ -n "$docker_codename" ]] || die 'failed to determine the Ubuntu codename'

printf '%s\n' \
	'Types: deb' \
	'URIs: https://download.docker.com/linux/ubuntu' \
	"Suites: $docker_codename" \
	'Components: stable' \
	"Architectures: $docker_arch" \
	"Signed-By: $DOCKER_KEYRING" >"$source_tmp" || die 'failed to write the Docker package source'
chmod 0644 "$source_tmp" || die 'failed to set permissions on the Docker package source'
mv -f -- "$source_tmp" "$DOCKER_SOURCE" || die 'failed to install the Docker package source'

apt-get "${APT_OPTIONS[@]}" update || die 'failed to update Apt metadata with the Docker package source'
apt-get "${APT_OPTIONS[@]}" install "${DOCKER_PACKAGES[@]}" || die 'failed to install Docker packages'
systemctl daemon-reload || die 'failed to reload systemd'
systemctl enable docker.service docker.socket || die 'failed to enable Docker'
systemctl restart docker.socket docker.service || die 'failed to restart Docker'
install -m 0755 -d "$(dirname -- "$PROVISION_MARKER")" || die 'failed to create the system provision marker directory'
touch "$PROVISION_MARKER" || die "failed to create system provision marker: $PROVISION_MARKER"

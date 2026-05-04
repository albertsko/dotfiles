#!/usr/bin/env bash

set -euo pipefail

if [[ "$EUID" -eq 0 ]]; then
	echo "Error: Run this script as your regular desktop user, not root." >&2
	exit 1
fi

if [[ ! -f /etc/os-release ]]; then
	echo "Error: /etc/os-release is missing." >&2
	exit 1
fi

# shellcheck disable=SC1091
. /etc/os-release
ubuntu_codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"

if [[ -z "$ubuntu_codename" ]]; then
	echo "Error: Ubuntu codename not found in /etc/os-release." >&2
	exit 1
fi

for package in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
	sudo apt-get remove -y "$package" >/dev/null 2>&1 || true
done

sudo apt-get update
sudo apt-get install -y ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

docker_sources_file="/etc/apt/sources.list.d/docker.sources"
docker_sources_tmp="$(mktemp)"
trap 'rm -f "$docker_sources_tmp"' EXIT

cat >"$docker_sources_tmp" <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $ubuntu_codename
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

if ! sudo test -f "$docker_sources_file" || ! sudo cmp -s "$docker_sources_tmp" "$docker_sources_file"; then
	sudo install -m 0644 "$docker_sources_tmp" "$docker_sources_file"
fi

sudo rm -f /etc/apt/sources.list.d/docker.list

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json >/dev/null <<'EOF'
{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}
EOF

sudo usermod -aG docker "$USER"

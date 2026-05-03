#!/usr/bin/env bash

set -euo pipefail

if [[ ! -f /etc/os-release ]]; then
	echo "Error: /etc/os-release is missing." >&2
	exit 1
fi

# shellcheck disable=SC1091
. /etc/os-release

if [[ "${ID:-}" != "ubuntu" ]]; then
	echo "Error: Ubuntu is required." >&2
	exit 1
fi

if ! dpkg --compare-versions "${VERSION_ID:-0}" ge "24.04"; then
	echo "Error: Ubuntu 24.04 LTS or newer is required." >&2
	echo "Detected: ${PRETTY_NAME:-unknown}" >&2
	exit 1
fi

ARCH="$(uname -m)"
if [[ "$ARCH" != "x86_64" ]]; then
	echo "Error: x86_64 architecture is required." >&2
	echo "Detected: $ARCH" >&2
	exit 1
fi

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y ca-certificates curl git stow unzip

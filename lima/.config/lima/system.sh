#!/usr/bin/env bash
set -euo pipefail

readonly PACKAGES=(build-essential ca-certificates curl docker.io file git procps)

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install --yes "${PACKAGES[@]}"

systemctl daemon-reload
systemctl enable docker.socket docker.service
systemctl restart docker.socket docker.service

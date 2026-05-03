#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

if [[ "$EUID" -eq 0 ]]; then
	echo "Error: Run this script as your regular desktop user, not root." >&2
	exit 1
fi

apt_packages=(
	apache2-utils
	build-essential
	clang
	file
	plocate
	procps
)

brew_packages=(
	autoconf
	bat
	bison
	eza
	fd
	fish
	fzf
	libpq
	libyaml
	mupdf-tools
	mysql-client
	pipx
	pkgconf
	redis
	ripgrep
	rust
	starship
	vips
	zoxide
)

sudo add-apt-repository universe -y
sudo apt-get update
sudo apt-get install -y "${apt_packages[@]}"

# shellcheck disable=SC1091
. "$SCRIPT_DIR/eval-brew.sh" || true

if ! command -v brew >/dev/null 2>&1; then
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# shellcheck disable=SC1091
. "$SCRIPT_DIR/eval-brew.sh"

if ! command -v brew >/dev/null 2>&1; then
	echo "Error: Homebrew is not available after installation." >&2
	exit 1
fi

brew analytics off
brew install "${brew_packages[@]}"

#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

if [[ "$EUID" -eq 0 ]]; then
	echo "Error: Run this script as your regular desktop user, not root." >&2
	exit 1
fi

apt_packages=(
	build-essential pkg-config autoconf bison clang rustc pipx
	libssl-dev libreadline-dev zlib1g-dev libyaml-dev libncurses5-dev libffi-dev libgdbm-dev libjemalloc2
	libvips imagemagick libmagickwand-dev mupdf mupdf-tools
	redis-tools sqlite3 libsqlite3-0 libmysqlclient-dev libpq-dev postgresql-client postgresql-client-common
)

brew_packages=(bat eza jq fd fish fzf go ripgrep starship zoxide)

sudo add-apt-repository universe -y
sudo apt-get update
sudo apt-get install -y "${apt_packages[@]}"

. "$SCRIPT_DIR/eval-brew.sh" || true

if ! command -v brew >/dev/null 2>&1; then
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

. "$SCRIPT_DIR/eval-brew.sh"

if ! command -v brew >/dev/null 2>&1; then
	echo "Error: Homebrew is not available after installation." >&2
	exit 1
fi

brew analytics off
brew install "${brew_packages[@]}"

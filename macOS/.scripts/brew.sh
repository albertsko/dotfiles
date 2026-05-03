#!/usr/bin/env bash

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_SHELLENV="$(/bin/zsh -lc 'brew shellenv')" || {
	echo "Error: Homebrew is installed, but brew is not available in a login shell." >&2
	exit 1
}
eval "$BREW_SHELLENV"

brew analytics off

BREW_PREFIX="$(brew --prefix)"
mkdir -p "$BREW_PREFIX/share"
sudo chmod -R go-w "$BREW_PREFIX/share"

CURR_DIR="$(dirname -- "$(realpath "${BASH_SOURCE[0]}")")"
brew bundle --file="$CURR_DIR/../Brewfile"

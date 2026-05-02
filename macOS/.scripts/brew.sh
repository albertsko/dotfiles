#!/usr/bin/env bash

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_BIN="$(command -v brew)"
eval "$("$BREW_BIN" shellenv)"
brew analytics off

mkdir -p /opt/homebrew/share
sudo chmod -R go-w /opt/homebrew/share

CURR_DIR="$(dirname -- "$(realpath "${BASH_SOURCE[0]}")")"
brew bundle --file="$CURR_DIR/../Brewfile"

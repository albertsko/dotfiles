#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$SCRIPT_DIR/../../..")}"
readonly DOTFILES_HOME
BREWFILE="$DOTFILES_HOME/shared/Brewfile"
readonly BREWFILE

if ! command -v brew >/dev/null 2>&1; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew_shellenv="$(/bin/zsh -lc 'brew shellenv')"
eval "$brew_shellenv"

brew analytics off

brew_prefix="$(brew --prefix)"
mkdir -p "$brew_prefix/share"
sudo chmod -R go-w "$brew_prefix/share"

brew bundle install --file="$BREWFILE"

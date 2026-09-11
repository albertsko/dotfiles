#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$SCRIPT_DIR/../../..")}"
BREWFILE="$DOTFILES_HOME/shared/Brewfile"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == "Darwin" ]] || die 'this script requires macOS'
[[ -f "$BREWFILE" ]] || die "Brewfile is missing: $BREWFILE"

if ! command -v brew >/dev/null 2>&1; then
	installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || die 'failed to download the Homebrew installer'
	/bin/bash -c "$installer" || die 'failed to install Homebrew'
fi

BREW_SHELLENV="$(/bin/zsh -lc 'brew shellenv')" || {
	die 'Homebrew is installed, but brew is not available in a login shell'
}
eval "$BREW_SHELLENV"

brew analytics off

BREW_PREFIX="$(brew --prefix)" || die 'failed to determine the Homebrew prefix'
mkdir -p "$BREW_PREFIX/share"
sudo chmod -R go-w "$BREW_PREFIX/share"

brew bundle install --file="$BREWFILE"
command -v stow >/dev/null 2>&1 || die 'stow was not installed by the Brewfile'

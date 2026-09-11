#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$SCRIPT_DIR/../../..")}"
readonly DOTFILES_HOME
BREWFILE="$DOTFILES_HOME/shared/Brewfile"
readonly BREWFILE

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

brew_shellenv="$(/bin/zsh -lc 'brew shellenv')" || die 'Homebrew is installed, but brew is not available in a login shell'
eval "$brew_shellenv" || die 'failed to apply the Homebrew environment'

brew analytics off || die 'failed to disable Homebrew analytics'

brew_prefix="$(brew --prefix)" || die 'failed to determine the Homebrew prefix'
mkdir -p "$brew_prefix/share" || die 'failed to create the Homebrew share directory'
sudo chmod -R go-w "$brew_prefix/share" || die 'failed to secure the Homebrew share directory'

brew bundle install --file="$BREWFILE" || die 'failed to install the shared Brewfile'
command -v stow >/dev/null 2>&1 || die 'stow was not installed by the Brewfile'

#!/usr/bin/env bash
set -euo pipefail

readonly BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$SCRIPT_DIR/..")}"
readonly BREWFILE="$DOTFILES_HOME/shared/Brewfile"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == "Linux" ]] || die 'this script requires Linux'
((EUID != 0)) || die 'this script must run as the default user, not root'
[[ -f "$BREWFILE" ]] || die "Brewfile is missing: $BREWFILE"

if [[ ! -x "$BREW_BIN" ]]; then
	installer="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || die 'failed to download the Homebrew installer'
	NONINTERACTIVE=1 /bin/bash -c "$installer" || die 'failed to install Homebrew'
fi

eval "$("$BREW_BIN" shellenv)"
brew analytics off
brew bundle install --no-upgrade --file="$BREWFILE"
command -v stow >/dev/null 2>&1 || die 'stow was not installed by the Brewfile'

# The Ubuntu image creates regular skeleton files at these paths. Remove only
# those regular files; repeated installs keep the existing Stow links intact.
for shell_file in "$HOME/.bashrc" "$HOME/.profile"; do
	if [[ -e "$shell_file" && ! -L "$shell_file" ]]; then
		rm -f -- "$shell_file"
	fi
done

#!/usr/bin/env bash
set -euo pipefail

readonly BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"
readonly SCRIPT_DIR
DOTFILES_HOME="${DOTFILES_HOME:-$(realpath -- "$SCRIPT_DIR/..")}"
readonly DOTFILES_HOME
readonly BREWFILE="$DOTFILES_HOME/shared/Brewfile"

[[ -x "$BREW_BIN" ]] || NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

"$BREW_BIN" analytics off
"$BREW_BIN" bundle install --no-upgrade --file="$BREWFILE"

for shell_file in "$HOME/.bashrc" "$HOME/.profile"; do
	[[ -L "$shell_file" ]] || rm -f -- "$shell_file"
done

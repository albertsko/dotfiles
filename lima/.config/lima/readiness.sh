#!/usr/bin/env bash
set -euo pipefail

XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
readonly XDG_STATE_HOME
DOTFILES_HOME="${DOTFILES_HOME:-$XDG_STATE_HOME/dotfiles}"
readonly DOTFILES_HOME
readonly BREW_BIN="/home/linuxbrew/.linuxbrew/bin/brew"
readonly GH_BIN="/home/linuxbrew/.linuxbrew/bin/gh"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

check_link() {
	local link_path=$1
	local expected_path
	local actual_path

	[[ -L "$link_path" ]] || die "required Stow link is missing: $link_path"
	actual_path="$(realpath -e -- "$link_path")" || die "required Stow link is broken: $link_path"
	expected_path="$(realpath -e -- "$2")" || die "expected Stow source is missing: $2"
	[[ "$actual_path" == "$expected_path" ]] || die "unexpected Stow link target for $link_path: $actual_path"
}

(($# == 0)) || die "unexpected argument: $1"
[[ "$(uname -s)" == "Linux" ]] || die 'this script requires Linux'
[[ -d "$DOTFILES_HOME/.git" ]] || die "dotfiles repository is missing: $DOTFILES_HOME"
command -v docker >/dev/null 2>&1 || die 'docker is not installed'
docker info >/dev/null 2>&1 || die 'Docker is not ready'
[[ -x "$BREW_BIN" ]] || die "Homebrew is not installed: $BREW_BIN"
"$BREW_BIN" --version >/dev/null 2>&1 || die 'Homebrew is not ready'
[[ -x "$GH_BIN" ]] || die "GitHub CLI is not installed: $GH_BIN"
"$GH_BIN" --version >/dev/null 2>&1 || die 'GitHub CLI is not ready'

check_link "$HOME/.profile" "$DOTFILES_HOME/lima/.profile"
check_link "$HOME/.bashrc" "$DOTFILES_HOME/lima/.bashrc"
check_link "$HOME/.profile.common" "$DOTFILES_HOME/shared/.profile.common"

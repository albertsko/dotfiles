#!/usr/bin/env bash
set -euo pipefail

readonly REPO_URL="https://github.com/albertsko/dotfiles.git"
readonly DOTFILES_REF="${PARAM_DOTFILES_REF:-main}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
readonly DOTFILES_HOME="${DOTFILES_HOME:-$XDG_STATE_HOME/dotfiles}"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

(($# == 0)) || die "unexpected argument: $1"
((EUID != 0)) || die 'this script must run as the default user, not root'
[[ -n "$DOTFILES_REF" ]] || die 'PARAM_DOTFILES_REF must not be empty'
command -v git >/dev/null 2>&1 || die 'git is not installed'

mkdir -p "$XDG_STATE_HOME"
if [[ ! -d "$DOTFILES_HOME/.git" ]]; then
	git clone --branch "$DOTFILES_REF" --single-branch "$REPO_URL" "$DOTFILES_HOME" || die 'failed to clone the dotfiles repository'
fi

export DOTFILES_HOME
export DOTFILES_PROFILE=lima
export DOTFILES_SSH_MODE=forwarded
bash "$DOTFILES_HOME/install.sh"

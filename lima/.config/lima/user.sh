#!/usr/bin/env bash
set -euo pipefail

readonly REPO_URL="https://github.com/albertsko/dotfiles.git"
readonly DOTFILES_REF="${PARAM_DOTFILES_REF:-main}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
readonly DOTFILES_HOME="${DOTFILES_HOME:-$XDG_STATE_HOME/dotfiles}"
readonly PROVISION_MARKER="$XDG_STATE_HOME/limadev/user-v1.done"

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

origin_url="$(git -C "$DOTFILES_HOME" remote get-url origin)" || die 'the dotfiles repository has no origin remote'
case "$origin_url" in
"$REPO_URL" | git@github.com:albertsko/dotfiles.git) ;;
*) die "unexpected dotfiles origin: $origin_url" ;;
esac

head_commit="$(git -C "$DOTFILES_HOME" rev-parse HEAD)" || die 'failed to resolve the dotfiles HEAD'
ref_commit="$(git -C "$DOTFILES_HOME" rev-parse --verify "${DOTFILES_REF}^{commit}")" || die "dotfiles ref is unavailable locally: $DOTFILES_REF"
[[ "$head_commit" == "$ref_commit" ]] || die "dotfiles checkout does not match configured ref: $DOTFILES_REF"

if [[ -f "$PROVISION_MARKER" && -x /home/linuxbrew/.linuxbrew/bin/brew && -x /home/linuxbrew/.linuxbrew/bin/gh && -L "$HOME/.profile" && -L "$HOME/.bashrc" && -L "$HOME/.profile.common" ]]; then
	exit 0
fi

export DOTFILES_HOME
export DOTFILES_PROFILE=lima
export DOTFILES_SSH_MODE=forwarded
bash "$DOTFILES_HOME/install.sh"

mkdir -p "$(dirname -- "$PROVISION_MARKER")"
touch "$PROVISION_MARKER"

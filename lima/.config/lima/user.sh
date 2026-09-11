#!/usr/bin/env bash
set -euo pipefail

readonly REPO_URL="https://github.com/albertsko/dotfiles.git"
readonly DOTFILES_REF="${PARAM_DOTFILES_REF:-main}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
readonly XDG_STATE_HOME
readonly DOTFILES_HOME="${DOTFILES_HOME:-$XDG_STATE_HOME/dotfiles}"
readonly PROVISION_MARKER="$XDG_STATE_HOME/limadev/user-v1.done"
readonly READINESS_SCRIPT="$DOTFILES_HOME/lima/.config/lima/readiness.sh"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

(($# == 0)) || die "unexpected argument: $1"
((EUID != 0)) || die 'this script must run as the default user, not root'
[[ -n "$DOTFILES_REF" ]] || die 'PARAM_DOTFILES_REF must not be empty'
command -v git >/dev/null 2>&1 || die 'git is not installed'

mkdir -p "$XDG_STATE_HOME" || die "failed to create state directory: $XDG_STATE_HOME"
if [[ ! -d "$DOTFILES_HOME/.git" ]]; then
	git clone --branch "$DOTFILES_REF" --single-branch "$REPO_URL" "$DOTFILES_HOME" || die 'failed to clone the dotfiles repository'
fi

origin_url="$(git -C "$DOTFILES_HOME" remote get-url origin)" || die 'the dotfiles repository has no origin remote'
case "$origin_url" in
"$REPO_URL" | git@github.com:albertsko/dotfiles.git) ;;
*) die "unexpected dotfiles origin: $origin_url" ;;
esac

git -C "$DOTFILES_HOME" fetch --force --quiet origin "$DOTFILES_REF" || die "dotfiles ref is unavailable from origin: $DOTFILES_REF"
head_commit="$(git -C "$DOTFILES_HOME" rev-parse --verify 'HEAD^{commit}')" || die 'failed to resolve the dotfiles HEAD'
remote_commit="$(git -C "$DOTFILES_HOME" rev-parse --verify 'FETCH_HEAD^{commit}')" || die "failed to resolve the fetched dotfiles ref: $DOTFILES_REF"
[[ "$head_commit" == "$remote_commit" ]] || die "dotfiles checkout does not match origin ref '$DOTFILES_REF'; rerun with --recreate"

if [[ -f "$PROVISION_MARKER" ]] && bash "$READINESS_SCRIPT" >/dev/null 2>&1; then
	exit 0
fi

export DOTFILES_HOME
export DOTFILES_PROFILE=lima
export DOTFILES_SSH_MODE=forwarded
bash "$DOTFILES_HOME/install.sh" || die 'failed to install the dotfiles'
bash "$READINESS_SCRIPT" || die 'dotfiles installation did not reach the required state'

mkdir -p "$(dirname -- "$PROVISION_MARKER")" || die 'failed to create the user provision marker directory'
touch "$PROVISION_MARKER" || die "failed to create user provision marker: $PROVISION_MARKER"

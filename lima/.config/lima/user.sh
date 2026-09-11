#!/usr/bin/env bash
set -euo pipefail

readonly REPO_URL="https://github.com/albertsko/dotfiles.git"
readonly DOTFILES_REF="${PARAM_DOTFILES_REF:-main}"
readonly STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
readonly DOTFILES_HOME="$STATE_HOME/dotfiles"
readonly MARKER="$STATE_HOME/limadev-user.done"

[[ -f "$MARKER" ]] && exit 0

mkdir -p "$STATE_HOME"
[[ -d "$DOTFILES_HOME/.git" ]] || git clone --branch "$DOTFILES_REF" --single-branch "$REPO_URL" "$DOTFILES_HOME"

env \
	DOTFILES_HOME="$DOTFILES_HOME" \
	DOTFILES_PROFILE=lima \
	DOTFILES_SSH_MODE=forwarded \
	bash "$DOTFILES_HOME/install.sh"

touch "$MARKER"

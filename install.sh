#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/albertsko/dotfiles.git"

export DOTFILES_DRY_RUN="${DOTFILES_DRY_RUN:-0}"
run() {
	if [[ "$DOTFILES_DRY_RUN" == "1" ]]; then
		echo "[dry-run]" "$@"
	else
		"$@"
	fi
}

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES_HOME="${DOTFILES_HOME:-$XDG_STATE_HOME/dotfiles}"

run mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$DOTFILES_HOME"

# setup DOTFILES_HOME
if [[ ! -d "$DOTFILES_HOME/.git" ]]; then
	run git clone "$REPO_URL" "$DOTFILES_HOME"
fi

# change remote to ssh
if [[ -d "$DOTFILES_HOME/.git" ]]; then
	current_remote="$(git -C "$DOTFILES_HOME" remote get-url origin)"
	if [[ "$current_remote" == https://github.com/* ]]; then
		ssh_url="git@github.com:${current_remote#https://github.com/}"
		run git -C "$DOTFILES_HOME" remote set-url origin "$ssh_url"
	fi
fi

printf 'Profile (macos/ubuntu26): '
read -r DOTFILES_PROFILE
[[ "$DOTFILES_PROFILE" == "macos" || "$DOTFILES_PROFILE" == "ubuntu26" ]] || exit 1
export DOTFILES_PROFILE

# install dotfiles
run bash "$DOTFILES_HOME/shared/_install.sh"
run bash "$DOTFILES_HOME/$DOTFILES_PROFILE/_install.sh"

# run stow
run bash "$DOTFILES_HOME/shared/.local/bin/stow.sh" --override

# install profile services
service_installer="$DOTFILES_HOME/$DOTFILES_PROFILE/.local/bin/entrypoint.sh"
if [[ -x "$service_installer" ]]; then
	run bash "$service_installer"
fi

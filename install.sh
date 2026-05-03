#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/albertsko/dotfiles.git"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES_HOME="$XDG_DATA_HOME/dotfiles"

mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$DOTFILES_HOME"

# setup DOTFILES_HOME
if [[ ! -d "$DOTFILES_HOME/.git" ]]; then
	git clone "$REPO_URL" "$DOTFILES_HOME"
fi

# change remote to ssh
current_remote="$(git -C "$DOTFILES_HOME" remote get-url origin)"
if [[ "$current_remote" == https://github.com/* ]]; then
	ssh_url="git@github.com:${current_remote#https://github.com/}"
	git -C "$DOTFILES_HOME" remote set-url origin "$ssh_url"
fi

# select profile
if [[ -z "$DOTFILES_PROFILE" ]]; then
	profiles=()
	for _dir in "$DOTFILES_HOME"/*/; do
		_name="$(basename "$_dir")"
		[[ "$_name" == _* ]] && continue
		profiles+=("$_name")
	done
	mapfile -t profiles < <(printf '%s\n' "${profiles[@]}" | sort)

	echo "Available profiles:"
	for _i in "${!profiles[@]}"; do
		echo "  [$_i] ${profiles[$_i]}"
	done
	echo ""

	read -rp "Enter profile number: " _num
	echo ""
	DOTFILES_PROFILE="${profiles[$_num]}"
fi
export DOTFILES_PROFILE

# install dotfiles
bash "$DOTFILES_HOME/_common/_install.sh"
bash "$DOTFILES_HOME/$DOTFILES_PROFILE/_install.sh"

# run stow
export DOTFILES_STOW_ADOPT=1
bash "$DOTFILES_HOME/_common/.scripts/stow.sh"

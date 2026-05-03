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
export DOTFILES_HOME="${DOTFILES_HOME:-$XDG_DATA_HOME/dotfiles}"

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

# select profile
if [[ -z "${DOTFILES_PROFILE:-}" ]]; then
	profiles=()
	for _dir in "$DOTFILES_HOME"/*/; do
		_name="$(basename "$_dir")"
		[[ "$_name" == _* ]] && continue
		profiles+=("$_name")
	done

	if ! [[ "${#profiles[@]}" -gt 1 ]]; then
		echo "Error: no profiles found in $DOTFILES_HOME." >&2
		exit 1
	fi

	_sorted=()
	while IFS= read -r _p; do _sorted+=("$_p"); done < <(printf '%s\n' "${profiles[@]}" | sort)
	profiles=("${_sorted[@]}")

	echo "Available profiles:"
	for _i in "${!profiles[@]}"; do
		echo "  [$_i] ${profiles[$_i]}"
	done
	echo ""

	read -rp "Enter profile number: " _num
	echo ""

	if ! [[ "$_num" =~ ^[0-9]+$ ]] || [[ "$_num" -ge "${#profiles[@]}" ]]; then
		echo "Error: invalid selection '$_num'." >&2
		exit 1
	fi

	DOTFILES_PROFILE="${profiles[$_num]}"
fi
export DOTFILES_PROFILE

# install dotfiles
run bash "$DOTFILES_HOME/_common/_install.sh"
run bash "$DOTFILES_HOME/$DOTFILES_PROFILE/_install.sh"

# run stow
bash "$DOTFILES_HOME/_common/.scripts/stow.sh"

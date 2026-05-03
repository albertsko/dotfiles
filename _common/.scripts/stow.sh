#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$DOTFILES_PROFILE" ]]; then
	echo "Error: DOTFILES_PROFILE is not set. Cannot stow dotfiles." >&2
	exit 1
fi

stow_flags=(--dir="$DOTFILES_HOME" --target="$HOME" --no-folding)
stow_flags+=(--restow)
if [[ "${DOTFILES_DRY_RUN:-0}" == "1" ]]; then
	stow_flags+=(-n -v)
fi

stow "${stow_flags[@]}" _common
stow "${stow_flags[@]}" "$DOTFILES_PROFILE"

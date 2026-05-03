#!/usr/bin/env bash

set -euo pipefail

if [[ -z "$DOTFILES_PROFILE" ]]; then
	echo "Error: DOTFILES_PROFILE is not set. Cannot stow dotfiles." >&2
	exit 1
fi

stow_flags=(--dir="$DOTFILES_HOME" --target="$HOME" --no-folding)
if [[ "$DOTFILES_STOW_ADOPT" == "1" ]]; then
	stow_flags+=(--adopt)
else
	stow_flags+=(--restow)
fi

stow "${stow_flags[@]}" _common
stow "${stow_flags[@]}" "$DOTFILES_PROFILE"

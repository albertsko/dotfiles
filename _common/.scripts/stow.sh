#!/usr/bin/env bash

set -euo pipefail

# resolve the real path of this script
_source="${BASH_SOURCE[0]}"
while [[ -L "$_source" ]]; do
	_dir="$(cd -P "$(dirname "$_source")" && pwd)"
	_source="$(readlink "$_source")"
	[[ "$_source" != /* ]] && _source="$_dir/$_source"
done
SCRIPT_DIR="$(cd -P "$(dirname "$_source")" && pwd)"

DOTFILES_HOME="${DOTFILES_HOME:-$(cd "$SCRIPT_DIR/../.." && pwd -P)}"
DOTFILES_PROFILE="${DOTFILES_PROFILE:-}"
DRY_RUN="${DOTFILES_DRY_RUN:-0}"
DELETE=0

# --delete / -D               → unstow instead of restow
# --simulate / -n / --dry-run → pass -n to stow (no changes written)
# <word>                      → profile override (overrides DOTFILES_PROFILE)
for arg in "$@"; do
	case "$arg" in
	--delete | -D) DELETE=1 ;;
	--simulate | -n | --dry-run) DRY_RUN=1 ;;
	--*) echo "Error: unknown flag '$arg'" >&2 && exit 1 ;;
	*) DOTFILES_PROFILE="$arg" ;;
	esac
done

if [[ -z "$DOTFILES_PROFILE" ]]; then
	echo "Error: DOTFILES_PROFILE is not set. Export it or pass it as an argument." >&2
	exit 1
fi

base_flags=(--dir="$DOTFILES_HOME" --target="$HOME" --no-folding --verbose=1)
[[ "$DRY_RUN" == "1" ]] && base_flags+=(-n)

if [[ "$DELETE" == "1" ]]; then
	echo "==> unstow $DOTFILES_PROFILE → $HOME"
	stow "${base_flags[@]}" --delete "$DOTFILES_PROFILE"
	echo "==> unstow _common → $HOME"
	stow "${base_flags[@]}" --delete _common
	exit 0
fi

echo "==> stow _common → $HOME"
stow "${base_flags[@]}" --restow --defer='.*' _common
echo "==> stow $DOTFILES_PROFILE → $HOME"
stow "${base_flags[@]}" --restow --override='.*' "$DOTFILES_PROFILE"

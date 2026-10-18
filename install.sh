#!/usr/bin/env bash
set -euo pipefail

readonly REPO_URL="https://github.com/albertsko/dotfiles.git"

export DOTFILES_DRY_RUN="${DOTFILES_DRY_RUN:-0}"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

run() {
	if [[ "$DOTFILES_DRY_RUN" != "1" ]]; then
		"$@"
		return
	fi

	printf '[dry-run]'
	printf ' %q' "$@"
	printf '\n'
}

(($# == 0)) || die "unexpected argument: $1"

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
current_remote=""
if [[ -d "$DOTFILES_HOME/.git" ]]; then
	current_remote="$(git -C "$DOTFILES_HOME" remote get-url origin)"
fi

if [[ "$current_remote" == https://github.com/* ]]; then
	ssh_url="git@github.com:${current_remote#https://github.com/}"
	run git -C "$DOTFILES_HOME" remote set-url origin "$ssh_url"
fi

DOTFILES_PROFILE="${DOTFILES_PROFILE:-}"
if [[ -z "$DOTFILES_PROFILE" ]]; then
	printf 'Profile (macos/ubuntu26/lima): '
	read -r DOTFILES_PROFILE
fi

case "$DOTFILES_PROFILE" in
macos | ubuntu26 | lima) ;;
*) die "unsupported profile: $DOTFILES_PROFILE" ;;
esac
export DOTFILES_PROFILE

# install dotfiles
run bash "$DOTFILES_HOME/shared/_install.sh"
run bash "$DOTFILES_HOME/$DOTFILES_PROFILE/_install.sh"

# Profile installers run in child shells, so import a newly installed Homebrew
# into this process before invoking tools supplied by the Brewfile.
for brew_bin in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew /usr/local/bin/brew; do
	[[ -x "$brew_bin" ]] || continue
	brew_shellenv="$("$brew_bin" shellenv)"
	eval "$brew_shellenv"
	break
done

# run stow
run bash "$DOTFILES_HOME/shared/.local/bin/stow.sh" --override

# install profile services
service_installer="$DOTFILES_HOME/$DOTFILES_PROFILE/.local/bin/gdrive.sh"
if [[ -x "$service_installer" ]]; then
	run bash "$service_installer"
fi

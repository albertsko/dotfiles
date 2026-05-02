#!/usr/bin/env bash

set -euo pipefail

REPO_URL="${DOTFILES_REPO_URL:-https://github.com/albertsko/dotfiles.git}"
PROFILE="${1:-${DOTFILES_PROFILE:-}}"

case "$PROFILE" in
macOS | macos | darwin) PROFILE="macOS" ;;
work) PROFILE="work" ;;
ubuntu | linux) PROFILE="ubuntu" ;;
*)
	echo "Unknown dotfiles profile: $PROFILE" >&2
	echo "Expected one of: macOS, work, ubuntu" >&2
	exit 1
	;;
esac

touch "$HOME/.hushlogin"

# Make XDG dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export DOTFILES_HOME="$XDG_DATA_HOME/dotfiles"

mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$(dirname "$DOTFILES_HOME")"

if [[ -d "$DOTFILES_HOME/.git" ]]; then
	git -C "$DOTFILES_HOME" pull --ff-only
else
	git clone "$REPO_URL" "$DOTFILES_HOME"
fi

ensure_homebrew() {
	if command -v brew >/dev/null 2>&1; then
		return
	fi

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

ensure_stow() {
	if command -v stow >/dev/null 2>&1; then
		return
	fi

	case "$(uname -s)" in
	Darwin)
		ensure_homebrew
		BREW_BIN="$(command -v brew)"
		eval "$("$BREW_BIN" shellenv)"
		brew install stow
		;;
	Linux)
		if command -v apt-get >/dev/null 2>&1; then
			sudo apt-get update
			sudo apt-get install -y stow
		else
			echo "GNU Stow is required. Install it with this machine's package manager and rerun." >&2
			exit 1
		fi
		;;
	*)
		echo "GNU Stow is required and no installer is defined for this OS." >&2
		exit 1
		;;
	esac
}

run_script() {
	local script="$1"

	if [[ -x "$script" ]]; then
		"$script"
	fi
}

stow_profiles() {
	local stow_flags=(--dir="$DOTFILES_HOME" --target="$HOME" --no-folding)
	if [[ "${DOTFILES_STOW_ADOPT:-0}" == "1" ]]; then
		stow_flags+=(--adopt)
	else
		stow_flags+=(--restow)
	fi

	stow "${stow_flags[@]}" _common "$PROFILE"
}

# Run scripts
if [[ "$PROFILE" == "macOS" ]]; then
	run_script "$DOTFILES_HOME/macOS/.scripts/sudo-touchid.sh"
	run_script "$DOTFILES_HOME/macOS/.scripts/brew.sh"
	run_script "$DOTFILES_HOME/macOS/.scripts/macos.sh"
fi

ensure_stow
run_script "$DOTFILES_HOME/_common/.scripts/ssh.sh"
run_script "$DOTFILES_HOME/_common/.scripts/git.sh"

# Plant dotfiles
stow_profiles

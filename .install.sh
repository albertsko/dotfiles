#!/usr/bin/env bash

set -euo pipefail
touch "$HOME/.hushlogin"

# Clone repo
TMP_DIR=$(mktemp -d -t "dotfiles")
cleanup() {
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT
git clone https://github.com/albertsko/dotfiles.git "$TMP_DIR"

# Make XDG dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_STATE_HOME"

# Run scripts
"$TMP_DIR/.scripts/sudo-touchid.sh"
"$TMP_DIR/.scripts/brew.sh"
"$TMP_DIR/.scripts/macos.sh"
"$TMP_DIR/.scripts/ssh.sh"
"$TMP_DIR/.scripts/git.sh"

# Plant dotfiles
rm -rf "$XDG_STATE_HOME/dotfiles"
git clone --bare git@github.com:albertsko/dotfiles.git "$XDG_STATE_HOME/dotfiles"
git --git-dir="$XDG_STATE_HOME/dotfiles/" --work-tree="$HOME" checkout --force main
git --git-dir="$XDG_STATE_HOME/dotfiles/" --work-tree="$HOME" config --local status.showUntrackedFiles no

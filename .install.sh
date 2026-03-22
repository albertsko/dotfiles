#!/bin/zsh
set -euo pipefail
touch "$HOME/.hushlogin"

# Clone repo
TMP_DIR=$(mktemp -d -t "dotfiles")
cleanup() {
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT
git clone https://github.com/albertsko/dotfiles.git "$TMP_DIR"

# Run scripts
source "$TMP_DIR/.zprofile"
"$TMP_DIR/.scripts/sudo-touchid.sh"
"$TMP_DIR/.scripts/brew.sh"
"$TMP_DIR/.scripts/macos.sh"
"$TMP_DIR/.scripts/ssh.sh"
"$TMP_DIR/.scripts/git.sh"

# Plant dotfiles
rm -rf "$XDG_STATE_HOME/dotfiles"
git clone --bare git@github.com:albertsko/dotfiles.git "$XDG_STATE_HOME/dotfiles"
git --git-dir="$XDG_STATE_HOME/dotfiles/" --work-tree="$HOME" checkout --force main

# Source dotfiles
source "$HOME/.zprofile"
source "$HOME/.zshrc"
cfg config --local status.showUntrackedFiles no

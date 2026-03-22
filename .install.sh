#!/bin/zsh
set -euo pipefail

TMP_DIR=$(mktemp -d -t "dotfiles")
cleanup() {
	rm -rf "$TMP_DIR"
}
trap cleanup EXIT

git clone https://github.com/albertsko/dotfiles.git "$TMP_DIR"
source "$TMP_DIR/.zprofile"

"$TMP_DIR/.scripts/brew.sh"
brew bundle --file "$TMP_DIR/Brewfile"

"$TMP_DIR/.scripts/macos.sh"
"$TMP_DIR/.scripts/ssh.sh"
"$TMP_DIR/.scripts/git.sh"

echo "Planting Configuration Files..."

rm -rf "$XDG_STATE_HOME/dotfiles"
git clone --bare git@github.com:albertsko/dotfiles.git "$XDG_STATE_HOME/dotfiles"
git --git-dir="$XDG_STATE_HOME/dotfiles/" --work-tree="$HOME" checkout --force main

source "$HOME/.zprofile"
source "$HOME/.zshrc"
cfg config --local status.showUntrackedFiles no

echo "Linking iCloud to $HOME/.icloud"
mkdir -p "$HOME/Library/Mobile Documents/com~apple~CloudDocs"
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/.icloud"

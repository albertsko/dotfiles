#!/bin/zsh
set -euo pipefail

export XDG_CONFIG_HOME="$HOME/.config"

./.scripts/brew.sh
./.scripts/apps.sh
./.scripts/macos.sh
./.scripts/git.sh

echo "Planting Configuration Files..."
rm -rf "$HOME/dotfiles"
git clone --bare git@github.com:albertsko/dotfiles.git "$HOME/dotfiles"
git --git-dir="$HOME/dotfiles/" --work-tree="$HOME" checkout --force main
source "$HOME/.zshrc"
cfg config --local status.showUntrackedFiles no

mkdir -p "$HOME/Library/Mobile Documents/com~apple~CloudDocs"
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" "$HOME/iCloud"

mkdir -p ~/.docker
echo '{}' >~/.docker/config.json
jq '.cliPluginsExtraDirs = ["/opt/homebrew/lib/docker/cli-plugins"]' ~/.docker/config.json >~/.docker/config.json.tmp && mv ~/.docker/config.json.tmp ~/.docker/config.json

echo "Let's finish our setup with some manual work:"
echo
echo "Install Xcode with: mas install 497799835"
echo "and run:            sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"

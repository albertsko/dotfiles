#!/bin/zsh

## Formulae
echo "Installing Brew Formulae..."
brew install wget jq ripgrep mas gh

### Terminal
brew install starship zoxide
brew install zsh-autosuggestions zsh-fast-syntax-highlighting

### Containers
brew install docker docker-compose docker-buildx
brew install kubernetes-cli minikube k9s helm cri-tools
brew install podman podman-compose

### Programming
brew install go lua python deno shellcheck
brew install go-task sqlc goose

### Nice to have
brew install lazygit lazydocker lazysql htop tldr bat xh

## Casks
echo "Installing Brew Casks..."
brew install --cask ghostty
brew install --cask hammerspoon
brew install --cask rectangle
brew install --cask zen-browser
brew install --cask vivaldi
brew install --cask vlc
brew install --cask obsidian
brew install --cask zed
brew install --cask visual-studio-code
brew install --cask podman-desktop

### Fonts
brew install --cask sf-symbols
brew install --cask font-sf-mono
brew install --cask font-sf-pro
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-inter

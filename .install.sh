#!/bin/zsh
export XDG_CONFIG_HOME="$HOME/.config"

# Install Xcode CLI tools
echo "Installing commandline tools..."
xcode-select --install

# Homebrew
## Install
echo "Installing Brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew analytics off

## Taps
echo "Tapping Brew..."
brew tap koekeishiya/formulae

## Formulae
echo "Installing Brew Formulae..."
brew install wget
brew install jq
brew install ripgrep
brew install mas
brew install gh
brew install skhd
brew install rclone

### Terminal
brew install starship
brew install zsh-autosuggestions
brew install zsh-fast-syntax-highlighting
brew install zoxide

### Containers
brew install docker
brew install kubernetes-cli
brew install minikube
brew install k9s
brew install lazydocker
brew install docker-compose

### Programming
brew install go
brew install python
brew install deno
brew install shellcheck

### Nice to have
brew install htop
brew install lazygit
brew install tldr
brew install bat
brew install xh

## Casks
echo "Installing Brew Casks..."
brew install --cask ghostty
brew install --cask karabiner-elements
brew install --cask google-chrome
brew install --cask vivaldi
brew install --cask zoom
brew install --cask slack
brew install --cask vlc
brew install --cask obsidian
brew install --cask nikitabobko/tap/aerospace

### Fonts
brew install --cask sf-symbols
brew install --cask font-sf-mono
brew install --cask font-sf-pro
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-inter

# Other
echo "Changing macOS defaults..."
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1 # enable browsing of all network interfaces
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # prevent creation of .ds_store files on network drives
defaults write com.apple.spaces spans-displays -bool false # disable spaces spanning multiple displays
defaults write com.apple.dock autohide -bool true # enable dock auto-hide
defaults write com.apple.dock autohide-delay -float 0 # start showing dock immediately
defaults write com.apple.dock autohide-time-modifier -float 0.5 # show whole dock in 0.5s
defaults write com.apple.dock "mru-spaces" -bool "false" # disable automatically rearranging spaces based on recent use
defaults write com.apple.dock persistent-apps -array # detach tails from dock
defaults write com.apple.dock persistent-others -array # detach others from dock
defaults write com.apple.dock show-recents -bool false # do not show recents in dock
defaults write com.apple.dock contents-immutable -bool true # make dock content immutable
defaults write com.apple.dock minimize-to-application -bool true # minimize windows to app's icon
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false # disable window opening animations
defaults write com.apple.LaunchServices LSQuarantine -bool false # disable quarantine prompt for downloaded apps
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false # disable natural scrolling
defaults write NSGlobalDomain KeyRepeat -int 1 # set keyboard repeat rate to fast
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # disable automatic spelling correction
defaults write NSGlobalDomain AppleShowAllExtensions -bool true # show all file extensions in finder
# defaults write NSGlobalDomain _HIHideMenuBar -bool true # hide the menu bar by default
# defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431" # set highlight color to a custom green
defaults write NSGlobalDomain AppleAccentColor -int 1 # set accent color to orange
defaults write com.apple.screencapture location -string "$HOME/Desktop" # set screenshot save location to desktop
defaults write com.apple.screencapture disable-shadow -bool true # disable screenshot shadow
defaults write com.apple.screencapture type -string "png" # set screenshot format to png
defaults write com.apple.finder DisableAllAnimations -bool true # disable finder animations
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false # hide external hard drives from desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false # hide internal hard drives from desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false # hide mounted servers from desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false # hide removable media from desktop
defaults write com.apple.Finder AppleShowAllFiles -bool true # show hidden files in finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # set finder search scope to current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # disable warning when changing file extensions
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true # show full path in finder title
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # set finder view style to list view
defaults write com.apple.finder ShowStatusBar -bool false # hide status bar in finder
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES # prevent time machine from offering new disks for backup
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false # disable copying email addresses with names in mail app
# defaults write -g NSWindowShouldDragOnGesture YES # allow dragging windows with three-finger gesture
sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false # disable safari auto-opening safe downloads
sudo defaults write com.apple.Safari IncludeDevelopMenu -bool true
sudo defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
sudo defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
killall Finder Dock SystemUIServer cfprefsd # apply most of the macOS defaults changes

## Fix for Bluetooth devices while using Wi-Fi
sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid

## Copying and checking out configuration files
echo "Planting Configuration Files..."
rm -rf $HOME/dotfiles
git clone --bare git@github.com:albsko/dotfiles.git $HOME/dotfiles
git --git-dir=$HOME/dotfiles/ --work-tree=$HOME checkout --force main

source $HOME/.zshrc
cfg config --local status.showUntrackedFiles no

skhd --start-service

## Link iCloud Drive to ~/iCloud
mkdir -p "$HOME/Library/Mobile Documents/com~apple~CloudDocs"
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ~/iCloud

## Make brew dir secure for compinit
sudo chmod -R go-w /opt/homebrew/share

# Manual
echo "Let's finish our setup with some manual work:"
echo
echo "Disable CTRL+SPACE shortcut (Settings -> Keyboard Shortcuts)"
echo
echo "Install Xcode, and run: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"

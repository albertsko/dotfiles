#!/bin/zsh

echo "Changing macOS defaults..."
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1                # enable browsing of all network interfaces
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # prevent creation of .ds_store files on network drives
defaults write com.apple.spaces spans-displays -bool false                   # disable spaces spanning multiple displays
defaults write com.apple.dock autohide -bool true                            # enable dock auto-hide
defaults write com.apple.dock autohide-delay -float 0                        # start showing dock immediately
defaults write com.apple.dock autohide-time-modifier -float 0.5              # show whole dock in 0.5s
defaults write com.apple.dock "mru-spaces" -bool "false"                     # disable automatically rearranging spaces based on recent use
defaults write com.apple.dock persistent-apps -array                         # detach tails from dock
defaults write com.apple.dock persistent-others -array                       # detach others from dock
defaults write com.apple.dock show-recents -bool false                       # do not show recents in dock
defaults write com.apple.dock contents-immutable -bool true                  # make dock content immutable
defaults write com.apple.dock minimize-to-application -bool true             # minimize windows to app's icon
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false # disable window opening animations
defaults write com.apple.LaunchServices LSQuarantine -bool false             # disable quarantine prompt for downloaded apps
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false # disable natural scrolling
defaults write NSGlobalDomain KeyRepeat -int 1                                 # set keyboard repeat rate to fast
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # disable automatic spelling correction
defaults write NSGlobalDomain AppleShowAllExtensions -bool true                # show all file extensions in finder
# defaults write NSGlobalDomain _HIHideMenuBar -bool true # hide the menu bar by default
# defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431" # set highlight color to a custom green
defaults write NSGlobalDomain AppleAccentColor -int 1                       # set accent color to orange
defaults write com.apple.screencapture location -string "$HOME/Desktop"     # set screenshot save location to desktop
defaults write com.apple.screencapture disable-shadow -bool true            # disable screenshot shadow
defaults write com.apple.screencapture type -string "png"                   # set screenshot format to png
defaults write com.apple.finder DisableAllAnimations -bool true             # disable finder animations
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false # hide external hard drives from desktop
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false         # hide internal hard drives from desktop
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false     # hide mounted servers from desktop
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false     # hide removable media from desktop
defaults write com.apple.Finder AppleShowAllFiles -bool true                # show hidden files in finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"         # set finder search scope to current folder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false  # disable warning when changing file extensions
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true          # show full path in finder title
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"         # set finder view style to list view
defaults write com.apple.finder ShowStatusBar -bool false                   # hide status bar in finder
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool YES  # prevent time machine from offering new disks for backup
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false  # disable copying email addresses with names in mail app
# defaults write -g NSWindowShouldDragOnGesture YES # allow dragging windows with three-finger gesture
sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false # disable safari auto-opening safe downloads
sudo defaults write com.apple.Safari IncludeDevelopMenu -bool true
sudo defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
sudo defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
sudo defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
sudo defaults write /Library/Preferences/com.apple.airport.bt.plist bluetoothCoexMgmt Hybrid # fix for Bluetooth devices while using Wi-Fi

## Auto arrange items in finder
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ListViewSettings:sortColumn name" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:ListViewSettings:columns:name:ascending true" ~/Library/Preferences/com.apple.finder.plist

## Set Hammerspoon config path
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

## Disable time machine, so macOS doesn't reindexes itself frequently
sudo tmutil disable

## Apply most of the macOS defaults changes
killall Finder Dock SystemUIServer cfprefsd

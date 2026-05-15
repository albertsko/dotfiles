#!/usr/bin/env bash
set -euo pipefail

brew update
brew outdated
brew upgrade
brew autoremove
brew cleanup
brew doctor

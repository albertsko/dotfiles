#!/usr/bin/env bash
set -euo pipefail

brew update
brew outdated
brew upgrade --yes
brew autoremove
brew cleanup
brew doctor

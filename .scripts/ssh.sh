#!/bin/zsh

KEY_PATH="$HOME/.ssh/id_ed25519"
KEY_COMMENT="$(date '+%Y-%m-%d %H:%M')"

if [ ! -f "$KEY_PATH" ]; then
  ssh-keygen -t ed25519 -C "$KEY_COMMENT" -f "$KEY_PATH"
fi

eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain "$KEY_PATH"

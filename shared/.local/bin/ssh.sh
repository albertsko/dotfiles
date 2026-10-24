#!/usr/bin/env bash

set -eu

KEY_PATH="$HOME/.ssh/id_ed25519"
CONFIG_PATH="$HOME/.ssh/config"
KEY_COMMENT="$(whoami)@$(hostname) - $(date '+%Y-%m-%d %H:%M')"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$KEY_PATH" ]; then
	ssh-keygen -q -t ed25519 -C "$KEY_COMMENT" -f "$KEY_PATH" -N ""
fi

if [ -z "${SSH_AUTH_SOCK:-}" ]; then
	eval "$(ssh-agent -s)" >/dev/null
fi

OS="$(uname -s)"

if [ ! -f "$CONFIG_PATH" ]; then
	{
		echo "Host *"
		echo "    AddKeysToAgent yes"
		if [ "$OS" = "Darwin" ]; then
			echo "    UseKeychain yes"
		fi
		echo "    ServerAliveInterval 60"
		echo "    ServerAliveCountMax 3"
		echo "    HashKnownHosts yes"
		echo ""
		echo "Host github.com"
		echo "    Hostname github.com"
		echo "    User git"
		echo "    IdentityFile $KEY_PATH"
		echo "    IdentitiesOnly yes"
	} >"$CONFIG_PATH"

	chmod 600 "$CONFIG_PATH"
fi

if [ "$OS" = "Darwin" ]; then
	ssh-add --apple-use-keychain "$KEY_PATH"
else
	ssh-add "$KEY_PATH"
fi

cat "${KEY_PATH}.pub"

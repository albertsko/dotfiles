#!/usr/bin/env bash
# Route GitHub SSH through ssh.github.com:443, which works on networks that block port 22.
# This script owns ~/.ssh/config.d/github.conf and rewrites it on every run.
# In ~/.ssh/config it only ensures the Include line, so the rest stays user-owned.
set -euo pipefail

readonly SSH_DIR="$HOME/.ssh"
readonly CONFIG_PATH="$SSH_DIR/config"
readonly CONFIG_D="$SSH_DIR/config.d"
readonly GITHUB_CONFIG="$CONFIG_D/github.conf"
readonly KEY_PATH="$SSH_DIR/id_ed25519"
# ssh_config uses the first value it finds, so the Include must come before any Host block.
readonly INCLUDE_LINE="Include config.d/*.conf"
SSH_MODE="${DOTFILES_SSH_MODE:-local}"
readonly SSH_MODE

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

case "$SSH_MODE" in
local | forwarded) ;;
*) die "unsupported DOTFILES_SSH_MODE: $SSH_MODE" ;;
esac

mkdir -p "$CONFIG_D"
chmod 700 "$SSH_DIR" "$CONFIG_D"

# Write to a temporary file first, so a failed run never leaves a partial config.
tmp="$(mktemp "$CONFIG_D/.github.conf.XXXXXX")"
{
	echo "# Managed by dotfiles (shared/.local/bin/ssh-github.sh). Local edits are overwritten."
	echo "Host github.com"
	echo "    Hostname ssh.github.com"
	echo "    Port 443"
	# ssh.github.com uses the same host keys as github.com, so reuse those known_hosts entries.
	echo "    HostKeyAlias github.com"
	echo "    User git"
	# In forwarded mode the key lives in the host agent, and IdentitiesOnly would hide it.
	if [[ "$SSH_MODE" == "local" ]]; then
		echo "    IdentityFile $KEY_PATH"
		echo "    IdentitiesOnly yes"
	fi
} >"$tmp"
chmod 600 "$tmp"
mv "$tmp" "$GITHUB_CONFIG"

if [[ ! -f "$CONFIG_PATH" ]]; then
	echo "$INCLUDE_LINE" >"$CONFIG_PATH"
	chmod 600 "$CONFIG_PATH"
fi

first_line="$(head -n 1 "$CONFIG_PATH")"
if [[ "$first_line" != "$INCLUDE_LINE" ]]; then
	tmp="$(mktemp "$SSH_DIR/.config.XXXXXX")"
	{
		echo "$INCLUDE_LINE"
		echo ""
		cat "$CONFIG_PATH"
	} >"$tmp"
	chmod 600 "$tmp"
	mv "$tmp" "$CONFIG_PATH"
fi

# The Include comes first, so github.conf wins over an older github.com block.
# The older block is dead config, so point it out for manual cleanup.
if grep -Eiq '^[[:space:]]*Host[[:space:]].*github\.com' "$CONFIG_PATH"; then
	printf 'Note: %s has its own github.com Host block. %s overrides it, so you can remove it.\n' \
		"$CONFIG_PATH" "$GITHUB_CONFIG" >&2
fi

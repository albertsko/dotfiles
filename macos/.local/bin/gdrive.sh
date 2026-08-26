#!/usr/bin/env bash
set -euo pipefail

readonly LABEL="com.albertsko.gdrive"
DOMAIN="gui/$(id -u)"
readonly DOMAIN
readonly PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"

die() {
	printf 'Error: %s\n' "$1" >&2
	exit 1
}

[[ ${DOTFILES_HOME:-} ]] || die 'DOTFILES_HOME is not set'
command -v go >/dev/null || die 'go is not installed'
command -v rclone >/dev/null || die 'rclone is not installed'

mkdir -p "$DOTFILES_HOME/apps/.bin"
go -C "$DOTFILES_HOME/apps/gdrive" build -o "$DOTFILES_HOME/apps/.bin/gdrive" .

launchctl bootout "$DOMAIN/$LABEL" >/dev/null 2>&1 || true
launchctl bootstrap "$DOMAIN" "$PLIST"
launchctl enable "$DOMAIN/$LABEL"
launchctl kickstart -k "$DOMAIN/$LABEL"

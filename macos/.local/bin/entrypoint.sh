#!/usr/bin/env bash
set -euo pipefail

label="com.albertsko.entrypoint"
domain="gui/$(id -u)"
plist="$HOME/Library/LaunchAgents/$label.plist"

launchctl bootout "$domain/$label" >/dev/null 2>&1 || true
launchctl bootstrap "$domain" "$plist"
launchctl enable "$domain/$label"
launchctl kickstart -k "$domain/$label"

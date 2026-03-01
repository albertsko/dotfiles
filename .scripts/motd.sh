#!/usr/bin/env bash

MOTD_FILE="$HOME/.config/motd.md"
LOCK_FILE="$HOME/.cache/motd.lock"
CURRENT_DATE=$(date +%Y-%m-%d)

BOOT_ID=$(who -b | md5)
CURRENT_STATE="${CURRENT_DATE}_${BOOT_ID}"

if [ ! -f "$MOTD_FILE" ]; then
	mkdir -p "$(dirname "$MOTD_FILE")"
	echo "# Setup MOTD, $(whoami)!" >"$MOTD_FILE"
	echo "Edit config file at $MOTD_FILE" >>"$MOTD_FILE"
fi

if [ -f "$LOCK_FILE" ]; then
	LAST_STATE=$(cat "$LOCK_FILE")
else
	LAST_STATE=""
fi

if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
	if command -v bat &>/dev/null; then
		bat "$MOTD_FILE"
	else
		cat "$MOTD_FILE"
	fi

	mkdir -p "$(dirname "$LOCK_FILE")"
	echo "$CURRENT_STATE" >"$LOCK_FILE"
fi

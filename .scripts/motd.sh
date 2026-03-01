#!/usr/bin/env bash

MOTD_FILE="$HOME/.config/motd.md"
LOCK_FILE="/tmp/motd.lastrun"
CURRENT_DATE=$(date +%Y-%m-%d)

if [ ! -f "$MOTD_FILE" ]; then
	mkdir -p "$(dirname "$MOTD_FILE")"
	echo "# Setup MOTD, $(whoami)!" >"$MOTD_FILE"
	echo "Edit config file at $MOTD_FILE" >>"$MOTD_FILE"
fi

if [ -f "$LOCK_FILE" ]; then
	LAST_RUN=$(cat "$LOCK_FILE")
else
	LAST_RUN=""
fi

if [ "$CURRENT_DATE" != "$LAST_RUN" ]; then
	if command -v bat &>/dev/null; then
		bat "$MOTD_FILE"
	else
		cat "$MOTD_FILE"
	fi

	echo "$CURRENT_DATE" >"$LOCK_FILE"
fi

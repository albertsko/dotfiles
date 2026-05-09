#!/usr/bin/env bash

set -euo pipefail

PAM_FILE="/etc/pam.d/sudo"
LINE='auth       sufficient     pam_tid.so'

if sudo grep -qxF "$LINE" "$PAM_FILE"; then
	exit 0
fi

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

{
	printf '%s\n' "$LINE"
	sudo cat "$PAM_FILE"
} >"$TMP_FILE"

sudo cp -p "$PAM_FILE" "${PAM_FILE}.bak"
sudo cp "$TMP_FILE" "$PAM_FILE"

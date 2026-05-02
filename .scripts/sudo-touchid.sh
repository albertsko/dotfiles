#!/usr/bin/env bash

PAM_FILE="/etc/pam.d/sudo"
LINE='auth       sufficient     pam_tid.so'

if sudo grep -qxF "$LINE" "$PAM_FILE"; then
	exit 0
fi

TMP_FILE=$(mktemp) || exit 1
echo "$LINE" >"$TMP_FILE"
cat "$PAM_FILE" | sudo tee -a "$TMP_FILE"
sudo cp "$PAM_FILE" "${PAM_FILE}.bak"
sudo mv "$TMP_FILE" "$PAM_FILE"

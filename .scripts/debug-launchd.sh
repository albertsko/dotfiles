#!/bin/zsh

PLIST_PATH=~/Library/LaunchAgents/com.local.AltTab.plist
LABEL="com.local.AltTab"

echo "Linting $PLIST_PATH..."
plutil -lint "$PLIST_PATH"

echo "Unloading agent..."
launchctl bootout gui/$(id -u)/$LABEL 2>/dev/null || echo "Agent was not loaded."

echo "Loading agent..."
launchctl bootstrap gui/$(id -u) "$PLIST_PATH"

echo "Forcing agent to run (kickstart)..."
launchctl kickstart -k gui/$(id -u)/$LABEL

echo "Waiting for logs..."
sleep 2
echo "--- STDOUT (/tmp/alttab.log) ---"
cat /tmp/alttab.log
echo "\n--- STDERR (/tmp/alttab-error.log) ---"
cat /tmp/alttab-error.log

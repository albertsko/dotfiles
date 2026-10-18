#!/usr/bin/env bash
set -euo pipefail

register_claude=false

while (($# > 0)); do
	case "$1" in
	--claude) register_claude=true ;;
	*)
		printf 'Usage: %s [--claude]\n' "${0##*/}" >&2
		exit 1
		;;
	esac
	shift
done

if "$register_claude"; then
	claude mcp add --scope user --transport stdio chrome-devtools -- \
		npx -y chrome-devtools-mcp@latest \
		--browser-url=http://127.0.0.1:9222
fi

# Brave must be fully quit for the debugging flag to take effect.
open -n -a "Brave Browser" --args --remote-debugging-port=9222

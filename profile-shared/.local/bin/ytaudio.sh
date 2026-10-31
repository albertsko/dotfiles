#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
	printf 'Usage: %s URL [URL ...]\n' "${0##*/}" >&2
	exit 2
fi

exec uv tool run --from 'yt-dlp[default]' yt-dlp --ignore-config --js-runtimes node --format bestaudio --paths "$HOME/youtube" -- "$@"

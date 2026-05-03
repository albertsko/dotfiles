#!/usr/bin/env bash

if command -v brew >/dev/null 2>&1; then
	eval "$(brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
	eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
else
	# shellcheck disable=SC2317
	return 1 2>/dev/null || exit 1
fi

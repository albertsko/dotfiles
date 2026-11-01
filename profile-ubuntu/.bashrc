# shellcheck shell=bash
if [[ $- != *i* ]]; then
	. "$HOME/.profile.shared"
	[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"
	return
fi

[[ -z "$BASH_EXECUTION_STRING" && "$(ps -o comm= -p "$PPID")" != fish ]] || return
command -v fish >/dev/null && exec fish

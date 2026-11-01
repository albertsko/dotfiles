[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"

# `bash -lic 'cmd'` is interactive too, so check for a command before replacing the shell.
[[ $- == *i* && -z "$BASH_EXECUTION_STRING" ]] || return
command -v fish >/dev/null && exec fish

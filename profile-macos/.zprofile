typeset -U PATH path FPATH fpath # macOS path_helper moves system paths first, so drop the later duplicates when the profile prepends them again.

. "$HOME/.profile.shared"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"

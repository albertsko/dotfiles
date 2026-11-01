# macOS path_helper moves system paths first, so drop the later duplicates when the profile prepends them again.
typeset -U PATH path FPATH fpath

[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"

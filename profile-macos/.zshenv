# Every zsh reads this file, including `zsh -c`, scripts, and `ssh host cmd`.
typeset -U fpath
[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"

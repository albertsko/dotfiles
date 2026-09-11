[[ $- == *i* ]] || return
[[ -z "${DOTFILES_FISH_ACTIVE:-}" ]] || return
command -v fish >/dev/null 2>&1 && exec env DOTFILES_FISH_ACTIVE=1 fish

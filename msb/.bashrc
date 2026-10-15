[[ $- == *i* ]] || return

if [[ -z "${DOTFILES_FISH_ACTIVE:-}" ]]; then
	command -v fish >/dev/null 2>&1 && exec env DOTFILES_FISH_ACTIVE=1 fish
fi

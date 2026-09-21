[[ $- == *i* ]] || return
if ! [[ -z "${DOTFILES_FISH_ACTIVE:-}" ]] && [[ -z "${HERDR_ENV:-}" ]]; then
	return
fi
command -v fish >/dev/null 2>&1 && exec env DOTFILES_FISH_ACTIVE=1 fish
# Lima BEGIN: keep Lima from changing this stowed file

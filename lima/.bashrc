[[ $- == *i* ]] || return

if [[ -z "${DOTFILES_FISH_ACTIVE:-}" ]] && [[ -z "${HERDR_ENV:-}" ]]; then
	command -v fish >/dev/null 2>&1 && exec env DOTFILES_FISH_ACTIVE=1 fish
	return
fi

if ! [[ -z "${HERDR_ENV:-}" ]]; then
	command -v fish >/dev/null 2>&1 && exec env DOTFILES_FISH_HERDR_ACTIVE=1 fish
	return
fi

if ! [[ -z "${DOTFILES_FISH_HERDR_ACTIVE:-}" ]]; then
	return
fi
# Lima BEGIN: keep Lima from changing this stowed file

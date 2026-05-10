if [[ "$PWD" == "$DOTFILES_HOME"* ]]; then
	. "$DOTFILES_HOME/.age/source.func"
	dotfiles-age-unlock
fi

[[ $- == *i* ]] || return
exec fish

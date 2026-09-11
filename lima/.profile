export DOTFILES_PROFILE=lima

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
# Lima BEGIN: keep Lima from changing this stowed file

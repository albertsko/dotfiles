export DOTFILES_PROFILE=lima

[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"
# Lima BEGIN: keep Lima from changing this managed file

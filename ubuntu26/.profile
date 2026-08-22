export DOTFILES_PROFILE=ubuntu26

[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"

[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"

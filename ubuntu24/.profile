[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"

export DOTFILES_PROFILE=ubuntu24

. "$DOTFILES_HOME/$DOTFILES_PROFILE/.scripts/eval-brew.sh"

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME/bin:"*) ;;
*) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

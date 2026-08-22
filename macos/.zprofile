export DOTFILES_PROFILE=macos
export VAULT_HOME="$HOME/Library/Mobile Documents/com~apple~CloudDocs/vault"

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

if [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"

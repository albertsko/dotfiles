export VAULT_HOME="$HOME/Library/Mobile Documents/com~apple~CloudDocs/vault"

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

[[ -f "$HOME/.profile.common" ]] && . "$HOME/.profile.common"
[[ -f "$HOME/.profile.local" ]] && . "$HOME/.profile.local"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export DOTFILES_HOME="$XDG_DATA_HOME/dotfiles"
export DEV_HOME="$HOME/dev"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.scripts"
export PATH="$PATH:$HOME/go/bin"

export EDITOR="vim"
export VISUAL="vim"
export MANPAGER="less -X"
export BAT_THEME="ansi"

[[ -f "$HOME/.profile.local" ]] && source "$HOME/.profile.local"

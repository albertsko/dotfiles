# Source zsh plugins
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

# Completions
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
	compinit
else
	compinit -C
fi

# Functions
fpath=(~/.scripts/functions "${fpath[@]}")
autoload -Uz gw diffy kkill

# Aliases
alias x="exit"
alias f="open ."
alias ssh="TERM=xterm-256color ssh"
alias http="xh"

## Git Aliases
alias add="git add"
alias commit="git commit"
alias pull="git pull"
alias push="git push"
alias stat="git status"
alias gdiff="git diff HEAD"
alias vdiff="git difftool HEAD"
alias log="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias cfg="git --git-dir=$XDG_STATE_HOME/dotfiles/ --work-tree=$HOME"
alias g="lazygit"

# Evaluations
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Exports
export PATH="$PATH:$HOME/.scripts"
export PATH="$PATH:$HOME/go/bin"
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
export PATH="/Users/albertsko/.local/bin:$PATH"
export PNPM_HOME="/Users/albertsko/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

export EDITOR="vim"
export VISUAL="vim"
export MANPAGER="less -X"

export BAT_THEME="ansi"

# Other
bindkey -e

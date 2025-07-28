# Source zsh plugins
source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

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
alias cfg="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias lcfg="lazygit --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias g="lazygit"

# Functions
function kill () {
  command kill -KILL $(pidof "$@")
}

# Evaluations
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Exports
export XDG_CONFIG_HOME="$HOME/.config"

export PATH="$PATH:$HOME/go/bin"

export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"

export EDITOR="$(which vim)"
export VISUAL="$(which vim)"
export MANPAGER="less -X"

# Other
bindkey -e

alias composer="$(brew --prefix php@8.3)/bin/php $(which composer)"

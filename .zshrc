# Source zsh plugins
BREW_PREFIX=$(brew --prefix)
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

# Aliases
alias x="exit"
alias f="open ."
alias z='open -a "Zen" --args -profile "$HOME/Documents/.browsers/zen"'
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

export EDITOR="$(which vim)"
export VISUAL="$(which vim)"
export MANPAGER="less -X"

# Other
bindkey -e

# Load zsh configuration for work at Fandom
if [[ -d "$HOME/Documents/github.com/Wikia" ]]; then
  source ~/.zshrc-fandom
fi

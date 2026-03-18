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

# Prompt
autoload -Uz colors && colors
setopt PROMPT_SUBST

C_BLACK="%F{black}"
C_DARKGRAY="%F{8}"
C_RESET="%f"

parse_git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  if [[ -n $branch ]]; then
    echo " ${C_BLACK}[${branch}]"
  fi
}

PROMPT="
${C_DARKGRAY}%~${C_RESET}\$(parse_git_branch)
${C_BLACK}>${C_RESET} "

# Functions
fpath=(~/.zsh/functions "${fpath[@]}")
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
alias cfg="git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias lcfg="lazygit --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias g="lazygit"

# Evaluations
eval "$(zoxide init --cmd cd zsh)"

# Exports
export XDG_CONFIG_HOME="$HOME/.config"
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

if [[ -d "$HOME/Documents/github.com/Wikia" ]]; then
	source ~/.zshrc-fandom
fi

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
	"$HOME/.scripts/motd.sh"
fi

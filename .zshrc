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
function kill() {
	command kill -KILL $(pidof "$@")
}

function diffy() {
	diff -u "$1" "$2" | delta --side-by-side
}

function gw() {
	local cmd=$1
	local name=$2
	local repo_root=$(git rev-parse --show-toplevel)
	local repo_name=$(basename "$repo_root")
	local parent_dir=$(dirname "$repo_root")

	case $cmd in
	"switch")
		if [ -z "$name" ]; then
			echo "Usage: gw switch <branch-name>"
			return 1
		fi
		local target_path="$parent_dir/$repo_name.$name"
		git worktree add -b "$name" "$target_path"
		cd "$target_path"
		;;
	"remove")
		if [ -z "$name" ]; then
			echo "Usage: gw remove <branch-name>"
			return 1
		fi
		local target_path="$parent_dir/$repo_name.$name"
		if [[ "$PWD" == "$target_path"* ]]; then
			cd "$parent_dir"
		fi
		git worktree remove "$target_path"
		git branch -d "$name"
		;;
	"list")
		git worktree list
		;;
	*)
		echo "Commands: switch, remove, list"
		;;
	esac
}

# Evaluations
eval "$(starship init zsh)"
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

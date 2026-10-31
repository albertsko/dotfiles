set -g fish_greeting

alias x exit
alias http xh
alias ssh 'env TERM=xterm-256color ssh'
alias zed 'zed -a'
alias zedgo 'zed "$(go env GOROOT)/../.."'

alias cfg 'git -C "$DOTFILES_HOME"'
abbr --add cdcfg 'cd "$DOTFILES_HOME"'
alias zedcfg 'zed --user-data-dir "$XDG_STATE_HOME/zed-dotfiles" --existing "$DOTFILES_HOME"'

abbr --add gd 'git diff HEAD'
abbr --add gc git checkout
abbr --add gs git status
abbr --add gl 'git log --oneline --graph --decorate'

abbr --add hd 'hunk diff'
abbr --add hs 'hunk show'

function ggg
    git add -A && git commit -m "$argv" && git pull --rebase; git push
end

if status is-interactive
    starship init fish | source
    zoxide init fish --cmd cd | source
    fzf --fish | source

    if type -q mise; and not set -q MISE_SHELL
        mise activate fish | source
    end
end

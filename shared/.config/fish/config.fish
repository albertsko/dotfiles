set -g fish_greeting
fish_vi_key_bindings

alias x exit
alias http xh
alias ssh 'env TERM=xterm-256color ssh'
alias zed 'zed -a'

alias cfg 'git -C "$DOTFILES_HOME"'
abbr --add cdcfg 'cd "$DOTFILES_HOME"'
alias zedcfg 'zed --user-data-dir "$XDG_STATE_HOME/zed-dotfiles" --existing "$DOTFILES_HOME"'

alias v 'git --git-dir="$VAULT_GIT_DIR" --work-tree="$VAULT_HOME"'
abbr --add cdv 'cd "$VAULT_HOME"'
alias zedv 'zed --user-data-dir "$XDG_STATE_HOME/zed-vault" --existing "$VAULT_HOME"'

abbr --add gd 'git diff HEAD'
abbr --add gc git checkout
abbr --add gs git status
abbr --add gl 'git log --oneline --graph --decorate'

function ggg
    git add -A && git commit -m "$argv" && git pull --rebase; git push
end

function vvv
    v add -A && v commit -m "$argv" && v pull --rebase; v push
end

if status is-interactive
    starship init fish | source
    zoxide init fish --cmd cd | source
    fzf --fish | source
end

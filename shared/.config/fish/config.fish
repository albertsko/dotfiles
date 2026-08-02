set -g fish_greeting
fish_vi_key_bindings

alias x exit
alias http xh
alias ssh 'env TERM=xterm-256color ssh'

alias cfg 'git -C "$DOTFILES_HOME"'
abbr --add cdcfg 'cd "$DOTFILES_HOME"'
alias zedcfg 'zed --user-data-dir "$XDG_STATE_HOME/zed-dotfiles" --existing "$DOTFILES_HOME"'

alias v 'git --git-dir="$VAULT_GIT_DIR" --work-tree="$VAULT_HOME"'
abbr --add cdv 'cd "$VAULT_HOME"'
alias zedv 'zed --user-data-dir "$XDG_STATE_HOME/zed-vault" --existing "$VAULT_HOME"'

abbr --add add git add
abbr --add commit git commit
abbr --add pull git pull
abbr --add push git push
abbr --add stat git status
abbr --add gdiff 'git diff HEAD'
abbr --add vdiff 'git difftool HEAD'
abbr --add gco git checkout
abbr --add gcb git checkout -b
abbr --add gst git status
abbr --add gl 'git log --oneline --graph --decorate'

function log
    git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $argv
end

function ggg
    git add -A && git commit -m "$argv" && git push
end

if status is-interactive
    starship init fish | source
    zoxide init fish --cmd cd | source
    fzf --fish | source
end

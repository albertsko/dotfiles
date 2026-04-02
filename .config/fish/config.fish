set -g fish_greeting
fish_vi_key_bindings

alias x exit
alias http xh
alias f 'open .'
alias ssh 'env TERM=xterm-256color ssh'
alias cfg 'git --git-dir=$XDG_STATE_HOME/dotfiles/ --work-tree=$HOME'

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

if status is-interactive
    starship init fish | source
    zoxide init fish --cmd cd | source
end

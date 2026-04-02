alias x exit
alias f 'open .'
alias ssh 'env TERM=xterm-256color ssh'
alias http xh
alias add 'git add'
alias commit 'git commit'
alias pull 'git pull'
alias push 'git push'
alias stat 'git status'
alias gdiff 'git diff HEAD'
alias vdiff 'git difftool HEAD'
alias cfg 'git --git-dir=$XDG_STATE_HOME/dotfiles/ --work-tree=$HOME'
alias g lazygit

function log
    git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $argv
end

if status is-interactive
    starship init fish | source
    zoxide init fish --cmd cd | source
end

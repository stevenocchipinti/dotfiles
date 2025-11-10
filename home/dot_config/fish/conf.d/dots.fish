alias dots="chezmoi --source ~/.dotfiles"
alias d=dots
alias dx="d status | fzf -m | cut -d ' ' -f 2 | xargs chezmoi --source ~/.dotfiles add"

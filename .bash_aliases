# tmux aliases
alias tls='tmux ls'
alias tnews='tmux new -s'
alias tattach='tmux attach -t'
alias tkill='tmux kill-session -t'
alias tkill-all='tmux ls -F#S | xargs -I@ tmux kill-session -t@'

# common utils colored
alias ls='ls --color=auto --group-directories-first -hN'
alias ll='ls -lA'

alias cgrep='grep --color=auto'
alias pgrep="grep --color=auto -P"

# git
alias lg='lazygit'

# python
alias bactivate='. venv/bin/activate || . .venv/bin/activate'

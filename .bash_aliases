# tmux aliases
alias tls='tmux ls'
alias tnews='tmux new -s'
alias tattach='tmux attach -t'
alias tkill='tmux kill-session -t'
alias tkill-all='tmux ls -F#S | xargs -I@ tmux kill-session -t@'

# common utils colored
alias ls='ls --color=auto --group-directories-first -h'
alias ll='ls -lA'

# python
alias vactivate='. venv/bin/activate 2> /dev/null || . .venv/bin/activate'

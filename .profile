export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export EDITOR="nvim"

if [ $(uname) = "Darwin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"

    for dir in $(brew --prefix)/opt/*/libexec/gnubin; do
        export PATH="$dir:$PATH"
    done;

    for dir in $(brew --prefix)/opt/*/libexec/gnuman; do
        export MANPATH="$dir:$MANPATH"
    done;

    export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
    export PATH="/opt/homebrew/opt/ccache/libexec:$PATH"
    export MallocNanoZone=0
fi

if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
    fi
fi

umask 0022
tmux has-session -t main 2> /dev/null
if [ $? != 0 ]; then
    tmux new -s main -dc ~

    tmux splitw -dvt main:0. -l5 htop
    tmux new-window -dc ~/.dotfiles -n dotfiles nvim .profile .bashrc .bashaliases
    tmux splitw -dht main:1. -c ~/.dotfiles
fi

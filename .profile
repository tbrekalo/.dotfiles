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

    if [ -f $HOME/.orbstack/shell/init.bash ]; then
        # Added by OrbStack: command-line tools and integration
        # This won't be added again if you remove it.
        source $HOME/.orbstack/shell/init.bash 2>/dev/null || :
    fi
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
    if [ $(uname) = "Darwin" ] && $(command -v ollama > /dev/null); then
        tmux send-keys -t main:0.0 "ollama run gemma3:12b" Enter "C-l"
        tmux splitw -dvt main:0.0 -c ~
    fi

    tmux new-window -dc ~/.dotfiles -n dotfiles nvim .profile .bashrc .bashaliases
    tmux splitw -dht main:1. -c ~/.dotfiles
fi

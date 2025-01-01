eval "$(/opt/homebrew/bin/brew shellenv)"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export EDITOR="nvim"

if [ $(uname)="Darwin" ]; then
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"

    export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
    export MANPATH="/opt/homebrew/opt/findutils/libexec/gnuman:$MANPATH"

    export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
    export MANPATH="/opt/homebrew/opt/grep/libexec/gnuman:$MANPATH"

    export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
    export MANPATH="/opt/homebrew/opt/gnu-getopt/man:$MANPATH"

    export PATH="/opt/homebrew/opt/gnu-indent/libexec/gnubin:$PATH"
    export MANPATH="/opt/homebrew/opt/gnu-indent/libexec/gnuman:$MANPATH"

    export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
    export MANPATH="/opt/homebrew/opt/gnu-sed/libexec/gnuman:$MANPATH"

    export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
    export MANPATH="/opt/homebrew/opt/gnu-tar/libexec/gnuman:$MANPATH"

    export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

    if [ -f $HOME/.orbstack/shell/init.bash ]; then
        # Added by OrbStack: command-line tools and integration
        # This won't be added again if you remove it.
        source $HOME/.orbstack/shell/init.bash 2>/dev/null || :
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ] ; then
  PATH="$HOME/go/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ] ; then
    . "$HOME/.cargo/env"
fi

if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

tmux has-session -t main
if [ $? != 0 ]; then
    tmux new -s main -dc ~

    tmux split-window -dvt main:0. -l5 htop
    tmux send-keys -t main:0.0 "ollama run qwen2.5-coder:7b" Enter
fi


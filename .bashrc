# Early exit for non-interactive shells
case $- in *i*) ;; *) return;; esac

# PATH setup
PATH=""
for dir in ~/.local/bin /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /bin /sbin; do
    [[ -d $dir ]] && PATH="${PATH:+$PATH:}$dir"
done
export PATH

# Editor
command -v nvim &>/dev/null && export EDITOR=nvim VISUAL=nvim

# History
HISTCONTROL=ignoreboth
HISTSIZE= HISTFILESIZE=
shopt -s histappend

# Shell options
shopt -s checkwinsize globstar

# PS1 (git branch + exit status indicator)
PS1='\[\e[1;38;5;120m\]\u@\h:\[\e[0;38;5;15m\]\w\[\e[38;5;210m\]$(git branch 2>/dev/null | sed -n "s/^\* \(.*\)/ (\1)/p")\[\e[0m\] $([ $? -eq 0 ] && echo "\[\e[32m\]" || echo "\[\e[31m\]")>\[\e[0m\] '

# Source files if they exist
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# OS-specific
case $(uname) in
    Linux)
        [[ -z ${debian_chroot:-} && -r /etc/debian_chroot ]] && debian_chroot=$(</etc/debian_chroot)
        ! shopt -oq posix && for f in /usr/share/bash-completion/bash_completion /etc/bash_completion; do
            [[ -f $f ]] && { . "$f"; break; }
        done ;;
    Darwin)
        [[ -e ~/.iterm2_shell_integration.bash ]] && . ~/.iterm2_shell_integration.bash
        [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]] && . /opt/homebrew/etc/profile.d/bash_completion.sh
        [[ -f /opt/homebrew/bin/fzf ]] && eval "$(fzf --bash)" ;;
esac

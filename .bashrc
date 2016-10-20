# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

set -o vi

# User specific aliases and functions
export P4EDITOR=vim
export EDITOR=vim

alias tmuxt="tmux a -t"
alias tmuxl="tmux list-sessions"

alias clip="nc localhost 8377"

source ~/.bashrc.arista

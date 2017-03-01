# .bashrc

# Source global definitions
# if [ -f /etc/bashrc ]; then
# 	. /etc/bashrc
# fi

alias vi="vim"
set -o vi

# User specific aliases and functions
export P4EDITOR=vim
export EDITOR=vim
export VISUAL=vim

alias tmuxt="tmux a -t"
alias tmuxs="tmux new-session -s"
alias tmuxl="tmux list-sessions"

alias clip="nc -U ~/.clipper.sock"

if [ -e ~/.bashrc.arista ]
then
   source ~/.bashrc.arista
fi

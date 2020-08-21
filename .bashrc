# .bashrc

# # Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export TERM=xterm-256color # Force proper coloring in tmux sessions

export PYTHONPATH=$PYTHONPATH:~/.vim/pylibs

alias vi="vim"
# set -o emacs
set -o vi

# User specific aliases and functions
export P4EDITOR=vim
export EDITOR=vim
export VISUAL=vim

alias g=grep
alias clip="nc -U ~/.clipper.sock"

function us106() {
   mosh joshpfosi@us106
}

export PATH=~/bin:$PATH

# Clear PROMPT_COMMAND from /etc/bashrc (see PS1 below)
if [[ "$(type -t timer_stop)" == "function" ]]; then
   PROMPT_COMMAND="timer_stop"
else
   PROMPT_COMMAND="history -a"
fi

PS1_chroot='[\u@\h$(ps1 $?)''% '
PS1_normal='[\u@\h$(ps1 $?)''\$ '

if [[ ! "$ARTOOLS_NOPROMPTMUNGE" == "1" ]]; then
   if [[ -e /p4conf ]]; then
      if [[ -n "$NS" ]]; then
         PS1="[\u@\h \W ($NS)]% "
      else
         PS1="$PS1_chroot"
         if [[ "$PWD" == "${A4_CHROOT}/src" ]]; then
            cd /src
         fi
      fi
   else
      PS1="$PS1_normal"
   fi
fi

if [ -e ~/.bashrc.arista ]
then
   source ~/.bashrc.arista
fi

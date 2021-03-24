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

function bus101() {
   mosh joshpfosi@bus101
}

function gbInfo() {
   if ! is-gb -q; then
      return
   fi
   # Don't do this inside a git repo
   if [ -d .git ]; then
      return
   fi
   out=$(agm current-topic 2>&1 </dev/null)
   if [[ $? -eq 0 ]]; then
      echo " ($out)"
   fi
}

source ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\w$(gbInfo)$(__git_ps1 " (%s)") \$ '

if [ -e ~/.bashrc.arista ]
then
   source ~/.bashrc.arista
fi

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
alias clip="nc localhost 8377"

function us219() {
   mosh joshpfosi@us219.sjc.aristanetworks.com
}

function shell() {
   HOST="joshpfosi-$(echo $1 | tr "._" "-")"
   echo "mosh $HOST"
   mosh $HOST
}

export PATH=~/bin:$PATH
# Add /Users/joshpfosi/Library/Python/3.8/bin to PATH for arkey (GPG signing) as
# it was installed there.
export PATH=/Users/joshpfosi/Library/Python/3.8/bin:$PATH
export PATH=".:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"

source $HOME/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\w$(__git_ps1 " (%s)")\$ '

if [ -e ~/.bashrc.arista ]
then
   source ~/.bashrc.arista
fi

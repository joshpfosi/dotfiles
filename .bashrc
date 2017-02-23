# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

alias vi="vim"
# alias vi="nvim"
set -o vi

# User specific aliases and functions
export P4EDITOR=vim
export EDITOR=vim
export VISUAL=vim

alias tmuxt="tmux a -t"
alias tmuxs="tmux new-session -s"
alias tmuxl="tmux list-sessions"

# alias clip="tmux loadb -"
alias clip="cat > ~/.clip.pipe"

source ~/.bashrc.arista

# Disabled as causes auto-complete issues
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash

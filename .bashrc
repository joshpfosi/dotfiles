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

function addmusic {
    # Get the best audio, convert it to MP3, and save it to the current
    # directory.
    youtube-dl --default-search=ytsearch: \
               --restrict-filenames \
               --format=bestaudio \
               --extract-audio \
               --audio-format=mp3 \
               --audio-quality=1 "$*"
    mv *.mp3 ~/Google\ Drive/Pfosi\'s\ Music\ Folder/
}

alias addmusic="addmusic"

if [ -e ~/.bashrc.arista ]
then
   source ~/.bashrc.arista
fi

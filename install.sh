#!/bin/sh

set -e
set -x

HOME=~
DOTFILES=$HOME/.dotfiles

ln -sf $DOTFILES/.vim/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/.bashrc $HOME/.bashrc
ln -sf $DOTFILES/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/.bash_profile $HOME/.bash_profile 
ln -sf $DOTFILES/.gitconfig $HOME/.gitconfig 
git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim 
vim -E -c PluginInstall -c q

launchAgentsDir=$HOME/Library/LaunchAgents
if [ -e $launchAgentsDir ]
then
   sudo ln -f com.joshpfosi.clipper.plist $launchAgentsDir/com.joshpfosi.clipper.plist
fi

#!/bin/sh

set -e
set -x

HOME=~
INSTALL_PATH="$(dirname "${BASH_SOURCE[0]}")"

echo "Symlinking from $INSTALL_PATH to $HOME..."

ln -sf $INSTALL_PATH/.vimrc $HOME/.vimrc
ln -sf $INSTALL_PATH/.bashrc $HOME/.bashrc
ln -sf $INSTALL_PATH/.tmux.conf $HOME/.tmux.conf
ln -sf $INSTALL_PATH/.bash_profile $HOME/.bash_profile
ln -sf $INSTALL_PATH/.gitconfig $HOME/.gitconfig

rm -rf $HOME/.vim
ln -sf $INSTALL_PATH/.vim $HOME/.vim

# VIM plugins
VUNDLE=$HOME/.vim/bundle/Vundle.vim
if [ -e $VUNDLE ]
then
   echo "$VUNDLE already present; not cloning..."
else
   git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE
fi
vim -E -c PluginInstall -c qa!

# Clipper set up
LAUNCH_AGENTS=$HOME/Library/LaunchAgents
if [ -e $LAUNCH_AGENTS ]
then
   sudo ln -f com.joshpfosi.clipper.plist $LAUNCH_AGENTS/com.joshpfosi.clipper.plist
fi

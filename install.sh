#!/bin/sh

set -e
set -x

HOME=~
INSTALL_PATH="$(dirname "${BASH_SOURCE[0]}")"

echo "Symlinking from $INSTALL_PATH to $HOME..."

ln -sf $INSTALL_PATH/.vimrc $HOME/.vimrc
ln -sf $INSTALL_PATH/.bashrc $HOME/.bashrc
ln -sf $INSTALL_PATH/.tmux $HOME/.tmux
ln -sf $INSTALL_PATH/.tmux.conf $HOME/.tmux.conf
ln -sf $INSTALL_PATH/.bash_profile $HOME/.bash_profile
ln -sf $INSTALL_PATH/.gitconfig $HOME/.gitconfig
ln -sf $INSTALL_PATH/.git-prompt.sh $HOME/.git-prompt.sh

rm -rf $HOME/.vim
ln -sf $INSTALL_PATH/.vim $HOME/.vim

echo "Installing homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Installing Vundle"
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

echo "Installing clipper"
brew install clipper

echo "Installing tmux"
brew install tmux

echo "Installing mosh"
brew install mosh

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

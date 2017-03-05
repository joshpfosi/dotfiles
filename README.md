# My Environment

This repository is for my personal use in rapidly setting up my development environment and computer in general. `GOTCHAS.md` is a collection of random tidbits I've learned over time that I am trying to keep in one place. `rvmrc` and `vimrc` should obviously be moved to `~/.rvmrc` and `~/.vimrc`, respectively.

## Installation

Run (assuming `git` is installed)

```
cd && rm -rf ~/.vim && \
git clone https://github.com/joshpfosi/dotfiles.git ~/.vim && \
ln -sf ~/.vim/.vimrc .vimrc && \
ln -sf ~/.vim/.rvmrc .rvmrc && \
ln -sf ~/.vim/.bashrc .bashrc && \
ln -sf ~/.vim/.zshrc .zshrc && \
ln -sf ~/.vim/.tmux.conf .tmux.conf && \
ln -sf ~/.vim/.bash_profile ~/.bash_profile && \
ln -sf ~/.vim/.sharedrc ~/.sharedrc && \
ln -f ~/.vim/config .ssh/config && \
sudo ln -f com.joshpfosi.clipper.plist \
~/Library/LaunchAgents/com.joshpfosi.clipper.plist && \
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
git config --global user.email "joshpfosi@gmail.com" && \
git config --global user.name "joshpfosi"
```

## Software

#### Homebrew
     ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#### Vundle
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#### Macvim (brew install macvim)
    brew install macvim
#### Clipper
    brew install clipper
#### tmux
    brew install tmux

#### Setting Up Clipper

Refer to `clipper.md` for details.

## Applications
* [Chrome](https://support.google.com/chrome/answer/95346?hl=en)
* [Drive](https://www.google.com/drive/download/)
* [Music Manager](https://support.google.com/googleplay/answer/1229970?hl=en)
<!---
* [Postgres.app](http://postgresapp.com/)
* [Java](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
-->
* [Latex](http://tug.org/mactex/mactex-download.html)

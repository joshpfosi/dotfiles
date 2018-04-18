# My Environment

This repository is for my personal use in rapidly setting up my development
environment. `GOTCHAS.md` is a collection of random tidbits I've learned over time
that I am trying to keep in one place.

## Installation

Run (assuming `git` is installed)

```
cd && rm -rf ~/.vim && \
git clone https://github.com/joshpfosi/dotfiles.git ~/.vim && \
ln -sf ~/.vim/.vimrc .vimrc && \
ln -sf ~/.vim/.bashrc .bashrc && \
ln -sf ~/.vim/.bashrc.arista ~/.bashrc.arista && \
ln -sf ~/.vim/.zshrc .zshrc && \
ln -sf ~/.vim/.tmux.conf .tmux.conf && \
ln -sf ~/.vim/.bash_profile ~/.bash_profile && \
ln -sf ~/.vim/.sharedrc ~/.sharedrc && \
ln -sf ~/.vim/.zshrc ~/.zshrc && \
ln -sf ~/.vim/.gitar_gitignore ~/.gitar_gitignore && \
ln -sf ~/.vim/.gitconfig ~/.gitconfig && \
ln -sf ~/.vim/.a4c ~/.a4c && \
ln -sf ~/.vim/.no_source_navigation ~/.no_source_navigation && \
ln -f ~/.vim/config .ssh/config && \
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
ln -sf ~/.vim/josh.zsh-theme ~/.oh-my-zsh/themes/ && \
git config --global user.email "joshpfosi@gmail.com" && \
git config --global user.name "joshpfosi" && \
sudo ln -f com.joshpfosi.clipper.plist \
~/Library/LaunchAgents/com.joshpfosi.clipper.plist
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
#### zsh
    brew install zsh zsh-completions
or
    sudo yum -y install zsh
#### oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#### mosh
    brew install mosh

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

# My Environment

This repository is for my personal use in rapidly setting up my development environment and computer in general. `GOTCHAS.md` is a collection of random tidbits I've learned over time that I am trying to keep in one place. `rvmrc` and `vimrc` should obviously be moved to `~/.rvmrc` and `~/.vimrc`, respectively.

## Installation

Run

```
cd && rm -rf ~/.vim && \
git clone https://github.com/joshpfosi/dotfiles.git ~/.vim && \
ln -sf ~/.vim/.vimrc .vimrc && \
ln -sf ~/.vim/.rvmrc .rvmrc && \
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Warning: This will obliterate your `.vim` directory, `.vimrc` and `.rvmrc`
files if they exist.

## Software

#### Homebrew
     ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#### NPM
     brew install npm
#### Postgres
    brew install postgresql
#### RVM & Rails
    \curl -sSL https://get.rvm.io | bash -s stable --rails
#### Ember CLI
    npm install -g ember-cli
#### Macvim (brew install macvim)
    brew install macvim
#### Vundle
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#### Rubocop (for Rails projects)
    gem install rubocop
#### JSHint
    npm install -g jshint

#### Disabling HTC One M8 automount

Whenever I plug in my phone, it automounts the HTC Sync Manager. To disable this follow the instructions found here on [Stack Exchange](http://apple.stackexchange.com/questions/108394/remove-htc-sync-manager-from-autostart), summarized as:

    diskutil info /Volumes/HTC\ Sync\ Manager | grep "UUID"
    sudo vifs

Append `UUID=<UUID> none hfs rw,noauto` to the file and save

## Applications
* [Chrome](https://support.google.com/chrome/answer/95346?hl=en)
* [Drive](https://www.google.com/drive/download/)
* [Music Manager](https://support.google.com/googleplay/answer/1229970?hl=en)
* [Postgres.app](http://postgresapp.com/)
* [Java](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

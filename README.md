# My Environment

This repository is for my personal use in easily setting up my development
environment. `GOTCHAS.md` is a collection of random tidbits I've learned over time
that I am trying to keep in one place.

## Installation

Run (assuming `git` is installed)
```
export DOTFILES=~/.dotfiles
git clone https://github.com/joshpfosi/dotfiles.git $DOTFILES
sh $DOTFILES/install.sh
```

## Software

#### Homebrew
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#### Vundle
    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#### oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#### Clipper
    brew install clipper
#### tmux
    brew install tmux
#### mosh
    brew install mosh

#### Setting Up Clipper

Refer to `clipper.md` for details.

#### Setting up BTT

* Export BetterTouchTool license via Configuration UI
* Enable "Remote Login" via "Sharing" settings on Mac (for ssh)
* Use scp to copy license
* Import presents / license

Software I used to use:

#### Macvim (brew install macvim)
    brew install macvim
#### zsh
    brew install zsh zsh-completions
or
    sudo yum -y install zsh

## Applications
* [Chrome](https://support.google.com/chrome/answer/95346?hl=en)
* [Drive](https://www.google.com/drive/download/)
* [Music Manager](https://support.google.com/googleplay/answer/1229970?hl=en)
* [f.lux](https://justgetflux.com/news/pages/macquickstart/#download)
<!---
* [Postgres.app](http://postgresapp.com/)
* [Java](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
-->
* [Latex](http://tug.org/mactex/mactex-download.html)

# Misc

# Annoying Mac iCloud pop up in system preferences

https://discussions.apple.com/thread/250786208:

First, check there's nothing else there:
```
defaults read com.apple.systempreferences AttentionPrefBundleIDs
```
This should dump:
```
{
    "com.apple.preferences.AppleIDPrefPane" = 1;
}
```
Then, delete:
```
defaults delete com.apple.systempreferences AttentionPrefBundleIDs
```
Then, close System Preferences.

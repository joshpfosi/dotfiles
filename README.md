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
ln -sf ~/.vim/.bashrc.arista .bashrc.arista && \
ln -sf ~/.vim/.tmux.conf .tmux.conf && \
ln -sf ~/.vim/config .ssh/config && \
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
git config --global user.email "joshpfosi@gmail.com" && \
git config --global user.name "joshpfosi"
```

Warning: This will obliterate your `.vim` directory, `.vimrc` and `.rvmrc`
files if they exist.

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

Set up `ssh` to automatically configure the shared connection back to the local
host. Add the following to `~/.ssh/config`:

```shell
Host *
  ControlPersist 240
  ControlMaster auto
  ControlPath ~/.ssh/%r@%h:%p
  RemoteForward 8377 localhost:8377
```

This causes every SSH connection to report back any data written to
`localhost:8377` on the remote host to `localhost:8377` on the local host, i.e.
Clipper. Clipper then writes it to the system clipboard. Aliases should be set
up on the remote host to make this process more seamless, e.g.:

```shell
alias clip="nc localhost 8377"
```

On Mac OS, `clipper` can run as a launch agent on startup. To configure this,
simply copy `com.joshpfosi.clipper.plist` to `/Users/<user>/Library/LaunchAgents`.

#### Disabling HTC One M8 automount

Whenever I plug in my phone, it automounts the HTC Sync Manager. To disable this follow the instructions found here on [Stack Exchange](http://apple.stackexchange.com/questions/108394/remove-htc-sync-manager-from-autostart), summarized as:

    diskutil info /Volumes/HTC\ Sync\ Manager | grep "UUID"
    sudo vifs

Append `UUID=<UUID> none hfs rw,noauto` to the file and save

## Applications
* [Chrome](https://support.google.com/chrome/answer/95346?hl=en)
* [Drive](https://www.google.com/drive/download/)
* [Music Manager](https://support.google.com/googleplay/answer/1229970?hl=en)
<!---
* [Postgres.app](http://postgresapp.com/)
* [Java](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
-->
* [Latex](http://tug.org/mactex/mactex-download.html)

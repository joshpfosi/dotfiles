  481  wget http://mirrors.mit.edu/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz
  482  tar -xvzf openssh-7.4p1.tar.gz
  483  ls openssh-7.4p1
  484  ls openssh-7.4p*
  485  ls
  486  tmuxl
  487  tmuxt pFS2
  488  tmuxt pipemonitor
  489  rm openssh-7.4p1.tar.gz
  490  cd openssh-7.4p1
  491  ./configure --prefix=/home/joshpfosi/bin
  492* which ssh
  493  make && make install
  494* ls bin
  495* vi bin/pipemonitor
  496  ../bin/sbin/sshd -p 8378
  497  sudo /home/joshpfosi/bin/sbin/sshd -p 8378
  ------------ must be sudo
  498* exit
  499* cat .bash_profile
  500* vi .bash_profile
  501* rm ~/.clip.pipe
  502* exit
  503* ls ~/.clipper*
  504* exit

# Server Setup

## Build and run new version of `ssh`

* We have to compile a new version of `ssh`. Currently it is 6.7. 

```
# install a new openssh version locally
wget http://mirrors.mit.edu/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz
tar -xvzf openssh-7.4p1.tar.gz
cd openssh-7.4p1
./configure --prefix=/home/joshpfosi/bin
make
make install
```

* Start the local `ssh` server by running:

```
/home/joshpfosi/bin/sbin/sshd -p 8378
```

* NOTE: port 8378 is arbitrary
* NOTE: must use an absolute path here

# Installing and Setting up Clipper on OSX

```sh
git clone git://git.wincent.com/clipper.git
cd clipper
# May need to `brew install go`
go build
sudo cp clipper /usr/local/bin

# Copy below plist file to ~/Library/LaunchAgents/com.joshpfosi

launchctl unload -w -S Aqua ~/Library/LaunchAgents/com.joshpfosi.clipper.plist
launchctl load -w -S Aqua ~/Library/LaunchAgents/com.joshpfosi.clipper.plist
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC -//Apple Computer//DTD PLIST 1.0//EN http://www.apple.com/DTDs/PropertyList-1.0.dtd >
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.wincent.clipper</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/bin/clipper</string>
		<string>--address</string>
		<string>~/.clipper.sock</string>
		<string>--logfile</string>
		<string>~/.clipper.log</string>
	</array>
	<key>EnvironmentVariables</key>
	<dict>
		<key>LANG</key>
		<string>en_US.UTF-8</string>
	</dict>
	<key>KeepAlive</key>
	<true/>
	<key>LimitLoadToSessionType</key>
	<string>Aqua</string>
</dict>
</plist>
```

#ssh config setup on osx
Add this to your ~/.ssh/config

```sh
# Allow sharing of multiple sessions over a single network connection
# With this configured, clipper, which requires a single connection over which
# to send back content, will not lose its connection when additional sessions to
# us102 are opened.
Host *
  ControlMaster auto
  ControlPath ~/.ssh/%r@%h:%p
  ControlPersist 240
  Port 8378

Host us102
  User joshpfosi
  Port 8378
  # Tell ssh to forward data from .clipper.sock on us102 to this host
  RemoteForward /home/joshpfosi/.clipper.sock /Users/joshpfosi/.clipper.sock
```

* Now things should be working

```
ssh us102
```

* This should create a `~/.clipper.sock` in the remote server. 

# Misc

* Use RSA encryption -- seems to play nicer than DSA with clipper

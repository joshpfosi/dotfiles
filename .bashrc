# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -e ~/.sharedrc ]
then
   source ~/.sharedrc
fi

case $- in
   (*i*) test -z "$ARTEST_RANDSEED" -a -f /bin/zsh && exec /bin/zsh;;
esac

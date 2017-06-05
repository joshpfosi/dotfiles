# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# If we are not in a test, enable custom configuration
if [ -z "$ARTEST_RANDSEED" ]
then
   if [ -e ~/.sharedrc ]
   then
      source ~/.sharedrc
   fi

   case $- in
      # If shell option 'i' is set, check that we are not running in a test and /bin/zsh
      # exists. If so, exec /bin/zsh.
      (*i*) test -f /bin/zsh && exec /bin/zsh;;
   esac
fi

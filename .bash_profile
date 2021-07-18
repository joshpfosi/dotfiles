# .bash_profile

# User specific environment and startup programs
export PATH=$PATH:$HOME/.local/bin
# For git paging
export LESS=FRX
export P4PORT=p4:1666
# For MacOS
export BASH_SILENCE_DEPRECATION_WARNING=1

# Gitarband
if [[ -d /src/.repo && -d .git ]]; then
   export TOPIC=$(agu-minimal current-topic)
   export MUT=$USER.$TOPIC
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# .bash_profile

# User specific environment and startup programs
export PATH=$HOME/gitar:$PATH:$HOME/.local/bin:$HOME/bin
# For git paging
export LESS=FRX

# This function is used to determine if we are in an a4c workspace, a home container
# or neither.
#
# @return 1 => neither, 2 => home container, 3 => a4c container
function get_env_type() {
   pstreeparent="$(pstree -s $$)"

   if [[ -d /src/.repo ]]; then
      # We are in a gitarband ws
      return 1
   elif [[ -n "$WP" ]]; then
      # We are in a gitar-v1 ws
      return 3
   elif [[ "$pstreeparent" =~ "dumb-init" ]]; then
      # We can see the docker processes, so assume we in the home container
      return 2
   else
      # Assume we are not in any container
      return 1
   fi
}

get_env_type
case "$?" in
   1) ;; # Do nothing
   2) cd ~ ;;
   3) cd /src ;;
esac

# Gitarband
if [[ -d /src/.repo && -d .git ]]; then
   export TOPIC=$(agu-minimal current-topic)
   export MUT=$USER.$TOPIC
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# .bash_profile

# User specific environment and startup programs
export PATH=$PATH:$HOME/.local/bin:$HOME/bin

# This function is used to determine if we are in an a4c workspace, a home container
# or neither.
#
# @return 1 => neither, 2 => home container, 3 => a4c container
function get_env_type() {
   pstreeparent="$(pstree -s $$)"

   if [[ -n "$WP" ]]; then
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
   1) a4c shell home ;;
   2) cd ~ ;;
   3) cd /src ;;
esac

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

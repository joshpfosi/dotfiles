if [[ -n "$NSNAME" ]]
then
   local nsname=" ($NSNAME)"
fi

if [[ -n "$A4_CHROOT" && -z "$ARTEST_RANDSEED" && $- =~ "i"  ]]
then
   local chrootvar=" %%"
fi

# This function is used to determine if we are in an a4c workspace, a home container
# or neither.
#
# @return 1 => neither, 2 => home container, 3 => a4c container
function get_env_type() {
   if ! [ -x "$(command -v pstree)" ]; then
      return 1
   fi

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
   1)
      local container=''
      ;;
   2)
      local container=' (home)'
      ;;
   3)
      # I don't know how to get the actual name. The hostname is pretty close
      local container=" ($(hostname | sed -e 's/\.sjc\..*//'))"
      ;;
   *)
      echo "Unknown env type"
      ;;
esac

# local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='$(git_prompt_info)%{$fg[cyan]%}%c%{$reset_color%}${nsname}${container}${chrootvar} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

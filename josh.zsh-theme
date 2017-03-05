if [[ -n "$A4_CHROOT" && -z "$ARTEST_RANDSEED" && $- =~ "i"  ]]
then
   local chrootvar="%% "
else
   local chrootvar=''
fi

# local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='$(git_prompt_info)%{$fg[cyan]%}%c%{$reset_color%} ${chrootvar}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

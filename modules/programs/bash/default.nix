{ config, options, lib, pkgs, ... }: {
  programs.bash = {
    shellAliases = {
      "~" = "cd ~";
      grep = "grep --color=auto";
    };
    promptInit = ''
      GIT_PS1_SHOWUNTRACKEDFILES=1
      GIT_PS1_SHOWUPSTREAM="auto"
      GIT_PS1_SHOWCOLORHINTS=1
      GIT_PS1_SHOWDIRTYSTATE=1
      GIT_PS1_SHOWSTASHSTATE=1
      GIT_PS1_SHOWUNTRACKEDFILES=1
      bold=$(tput bold)
      red=$(tput setaf 1)
      yellow=$(tput setaf 3)
      cyan=$(tput setaf 6)
      magenta=$(tput setaf 5)
      reset=$(tput sgr0)
      prompt_command(){
        local retval="''${?#0}"
        local prompt="\n"
        local prompt_end=""
        local jobsval=`jobs -p | wc -l`

        [ -n "$retval" ] && prompt+="$red$retval$reset "
        [ -n "$IN_NIX_SHELL" ] && prompt+="$cyan $reset "
        prompt+="$bold$yellow\w$reset"

        [ $jobsval -ne 0 ] && prompt_end+=" $bold$cyan$jobsval$reset"
        prompt_end+="\n"
        [ $(id -u) -eq 0 ] && prompt_end+="\[$red\]#" || prompt_end+="\[$magenta\]❯"
        prompt_end+="\[$reset\] "

        if type -t __git_ps1 > /dev/null 2>&1 ; then
          __git_ps1 "$prompt" "$prompt_end"
        else
          PS1="$prompt $prompt_end"
        fi
        history -a
      }
      PROMPT_COMMAND=prompt_command
    '';
    interactiveShellInit = ''
      PROMPT_DIRTRIM=3
      set -o notify

      shopt -s checkwinsize
      shopt -s globstar 2> /dev/null
      shopt -s nocaseglob;
      shopt -s autocd 2> /dev/null
      shopt -s dirspell 2> /dev/null
      shopt -s cdspell 2> /dev/null
      shopt -s histappend
      shopt -s cmdhist

      bind "set completion-ignore-case on"
      bind "set completion-map-case on"
      bind "set show-all-if-ambiguous on"
      bind "set menu-complete-display-prefix on"
      bind "set mark-symlinked-directories on"
      bind "set colored-stats on"
      bind "set visible-stats on"
      bind "set page-completions off"
      bind "set skip-completed-text on"
      bind "set bell-style none"

      bind '"\t": menu-complete'
      bind '"\e[Z": menu-complete-backward'
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\e[M": kill-word'
      bind '"\C-h": backward-kill-word'

      HISTSIZE=-1
      HISTFILESIZE=-1
      HISTIGNORE="&:[ ]*:exit:l:ls:ll:bg:fg:history*:clear:kill*:?:??"

      historymerge () {
        ${pkgs.gnused}/bin/sed 's/[[:space:]]*$//' $HISTFILE \
        | ${pkgs.coreutils}/bin/tac \
        | ${pkgs.gawk}/bin/awk '!x[$0]++' \
        | ${pkgs.coreutils}/bin/tac \
        | ${pkgs.moreutils}/bin/sponge $HISTFILE
      }
      trap historymerge EXIT

      stty -ixon
    '';
  };
}

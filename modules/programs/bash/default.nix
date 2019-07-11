{ config, options, lib, pkgs, ... }:
{
  programs.bash = {
    shellAliases= {
      hh="${pkgs.hstr}/bin/hh";
      "~"="cd ~";
      grep="grep --color=auto";
    };
    promptInit = ''
      GIT_PS1_SHOWUNTRACKEDFILES=1
      GIT_PS1_SHOWUPSTREAM="auto"
      GIT_PS1_SHOWCOLORHINTS=1
      GIT_PS1_SHOWDIRTYSTATE=1
      bold=$(tput bold)
      red=$(tput setaf 1)
      yellow=$(tput setaf 3)
      cyan=$(tput setaf 6)
      magenta=$(tput setaf 5)
      reset=$(tput sgr0)
      prompt_command(){
        local retval="''${?#0}"
        history -n; history -w; history -c; history -r
        local prompt="\n"
        local uid=""
        local job="\j"

        [ $(id -u) -eq 0 ]  && uid+="$jobs\n\[$red\]#\[$reset\]" || uid+="$jobs\n\[$magenta\]❯\[$reset\]"
        if [ -n "$(jobs -p)" ]; then uid+="$job"; fi
        if [ -n "$retval" ]; then prompt+="\[$red\]$retval\[$reset\] " ;fi
        if [ -n "$IN_NIX_SHELL" ]; then prompt+="\[$cyan\] \[$reset\] "; fi
        prompt+="\[$bold\]\[$yellow\]\w\[$reset\]"

        __git_ps1 "$prompt" "$uid "

      }
      PROMPT_COMMAND=prompt_command
      PROMPT_DIRTRIM=3
    '';
    interactiveShellInit= ''
      set -o notify
      bind "set completion-ignore-case on"
      bind "set completion-map-case on"
      bind "set show-all-if-ambiguous on"
      bind "set menu-complete-display-prefix on"
      bind "set mark-symlinked-directories on"
      bind "set colored-stats on"
      bind "set skip-completed-text on"
      bind "set visible-stats on"
      bind "set page-completions off"
      bind "set bell-style none"
      bind '"\t": menu-complete'
      bind '"\e[Z": menu-complete-backward'
      bind '"\e[P": delete-char'
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\C-h": backward-kill-word'
      bind '"\e[M": kill-word'
      bind Space:magic-space
      shopt -s checkwinsize
      shopt -s globstar 2> /dev/null
      shopt -s nocaseglob;
      shopt -s autocd 2> /dev/null
      shopt -s dirspell 2> /dev/null
      shopt -s cdspell 2> /dev/null
      shopt -s histappend
      shopt -s histreedit
      shopt -s histverify
      shopt -s cmdhist
      shopt -s lithist
      HISTFILESIZE=-1
      HISTSIZE=''${HISTFILESIZE}
      HH_CONFIG=hicolor
      HISTCONTROL=ignoreboth:erasedups
      eval `${pkgs.coreutils}/bin/dircolors "${./dircolors}"`
      source ${pkgs.fzf}/share/fzf/completion.bash
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
      bind '"\C-r": "\C-a hh -- \C-j"';
      bind '"\C-xk": "\C-a hh -k \C-j"'
      stty -ixon
    '';
  };
}

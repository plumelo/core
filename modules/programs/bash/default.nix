{ config, options, lib, pkgs, ... }:
{
  programs.bash = {
    shellAliases= {
      hh="${pkgs.hstr}/bin/hh";
      "~"="cd ~";
      grep="grep --color=auto";
    };
    promptInit = ''
      NL='
      '
      GIT_PS1_SHOWUNTRACKEDFILES=1
      GIT_PS1_SHOWUPSTREAM="auto"
      GIT_PS1_SHOWCOLORHINTS=1
      GIT_PS1_SHOWDIRTYSTATE=1
      VIRTUAL_ENV_DISABLE_PROMPT=1
      bold=$(tput bold)
      red=$(tput setaf 1)
      yellow=$(tput setaf 3)
      cyan=$(tput setaf 6)
      magenta=$(tput setaf 5)
      reset=$(tput sgr0)
      set_active_venv() {
        export ACTIVE_VENV=""
        if [ "$VIRTUAL_ENV" != "" ]; then
          export ACTIVE_VENV="(`basename \"$VIRTUAL_ENV\"`)"
        fi
      }
      active_nix_shell() {
        if [ -n "$IN_NIX_SHELL" ]; then
          export NSHELL="  "
        fi
      }
      PROMPT_COMMAND='\
        set_active_venv; active_nix_shell; __git_ps1 \
        "''${NL}\[$yellow\]''${ACTIVE_VENV}''${NSHELL}\[$reset\]\[$red\]\''${?#0}\[$reset\]\[$bold\]\[$cyan\]\w\[$reset\]" \
        "\[$magenta\]''${NL}❯\[$reset\] "'
      alias hfix='history -n && history | sort -k2 -k1nr | uniq -f1 | sort -n | cut -c8- > ~/.tmp$$ && history -c && history -r ~/.tmp$$ && history -w && rm ~/.tmp$$'
      PROMPT_COMMAND="hfix; $PROMPT_COMMAND"
    '';
    interactiveShellInit= ''
      shopt -s checkwinsize
      PROMPT_DIRTRIM=3
      bind Space:magic-space
      shopt -s globstar 2> /dev/null
      shopt -s nocaseglob;

      bind "set completion-ignore-case on"
      bind "set completion-map-case on"
      bind "set show-all-if-ambiguous on"
      bind "set menu-complete-display-prefix on"
      bind "set mark-symlinked-directories on"
      bind "set colored-stats on"
      bind "set skip-completed-text on"
      bind "set visible-stats on"
      bind "set mark-symlinked-directories on"
      bind "set page-completions off"
      bind "set skip-completed-text on"
      bind "set bell-style none"
      bind '"\t": menu-complete'
      bind '"\e[Z": menu-complete-backward'
      bind '"\e[P": delete-char'
      bind '"\e[A": history-search-backward'
      bind '"\e[B": history-search-forward'
      bind '"\e[C": forward-char'
      bind '"\e[D": backward-char'
      bind '"\C-h": backward-kill-word'
      bind '"\e[1;5C": forward-word'
      bind '"\e[1;5D": backward-word'
      bind '"\e[M": kill-word'
      shopt -s autocd 2> /dev/null
      shopt -s dirspell 2> /dev/null
      shopt -s cdspell 2> /dev/null

      set meta-flag on
      set input-meta on
      set output-meta on
      set convert-meta off

      LESS='-XFr'

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

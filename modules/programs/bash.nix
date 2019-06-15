{ config, options, lib, pkgs, ... }:
{
  programs.bash = {
    shellAliases= {
      hh="${pkgs.hstr}/bin/hh";
      "~"="cd ~";
    };
    promptInit = ''
      PS='\[\e[32m\]\w\[\e[m\]$(${pkgs.bashPackages.vcprompt}/bin/vcprompt --minimal) \[\e[35m\]$\[\e[m\] '
      function prompt_command() {
        if [[ -n "$IN_NIX_SHELL" ]]; then
          export PS1='\[\e[31m\]nix\[\e[m\] '$PS
        else
          export PS1=$PS
        fi
      }
      export PROMPT_DIRTRIM=1
      PROMPT_COMMAND=prompt_command
    '';
    interactiveShellInit= ''
      export EDITOR=nvim

      shopt -s histappend
      export HISTFILESIZE=10000
      export HISTSIZE=''${HISTFILESIZE}

      export HH_CONFIG=hicolor
      export HISTCONTROL=ignorespace
      export PROMPT_COMMAND="history -a; history -n; ''${PROMPT_COMMAND}"   # mem/file sync

      source ${pkgs.fzf}/share/fzf/completion.bash
      source ${pkgs.fzf}/share/fzf/key-bindings.bash

      bind '"\C-r": "\C-a hh -- \C-j"';
      bind '"\C-xk": "\C-a hh -k \C-j"'

    '';
  };
}

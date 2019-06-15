{ config, options, lib, pkgs, ... }:
{
  programs.bash = {
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
    '';
  };
}

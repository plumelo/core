{ config, options, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
      highlightStyle = "fg=9";
    };
    syntaxHighlighting.enable = true;
  };
  
  programs.zsh.promptInit = ''
    source ${pkgs.zshPlugins.nix-shell}/nix-shell.plugin.zsh
    autoload -U promptinit && promptinit && prompt spaceship
    export SPACESHIP_PROMPT_ORDER=(
      user          # Username section
      dir           # Current directory section
      host          # Hostname section
      git           # Git section (git_branch + git_status)
      package       # Package version
      node          # Node.js section
      exec_time     # Execution time
      line_sep      # Line break
      jobs          # Background jobs indicator
      exit_code     # Exit code section
      char          # Prompt character
    )

    export SPACESHIP_RPROMPT_ORDER=(
      vi_mode       # Vi-mode indicator
    )

    spaceship_vi_mode_enable
    bindkey '^P' up-history
    bindkey '^N' down-history

    bindkey '^?' backward-delete-char
    bindkey '^h' backward-delete-char

    # ctrl-w removed word backwards
    bindkey '^w' backward-kill-word

    export KEYTIMEOUT=1

    export EDITOR=nvim
  '';
  environment.systemPackages = with pkgs; [zshThemes.spaceship];
  users.defaultUserShell = pkgs.zsh; 

}


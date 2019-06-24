{ config, options, lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestions = {
      enable = true;
      highlightStyle = "fg=241";
    };
    syntaxHighlighting.enable = true;

    interactiveShellInit = ''
      source ${pkgs.zshPlugins.nix-shell}/nix-shell.plugin.zsh
      source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      bindkey -e
      bindkey '^P' up-history
      bindkey '^N' down-history
      zmodload zsh/terminfo
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down
      bindkey '\e[3~' delete-char
      bindkey '^H' vi-backward-kill-word
      bindkey '^w' vi-backward-kill-word
      bindkey '^R' history-incremental-pattern-search-backward
      bindkey '\e[1;5C' vi-forward-word            # C-Right
      bindkey '\e[1;5D' vi-backward-word           # C-Left
      bindkey '\e[5~'   history-search-backward # PgUp
      bindkey '\e[6~'   history-search-forward  # PgDn

      export EDITOR=nvim
      eval `${pkgs.coreutils}/bin/dircolors "${./dircolors}"`

      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=black,fg=yellow,bold'

      alias ..="cd ../"

      extract() {
        if [ -f "$1" ] ; then
          local filename=$(basename "$1")
          local foldername="''${filename%%.*}"
          local fullpath=$(perl -e 'use Cwd "abs_path";print abs_path(shift)' "$1")
          local didfolderexist=false
          if [ -d "$foldername" ]; then
            didfolderexist=true
            read -p "$foldername already exists, do you want to overwrite it? (y/n) " -n 1
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
              return
            fi
          fi
          mkdir -p "$foldername" && cd "$foldername"
          case $1 in
            *.tar.bz2) ${pkgs.gnutar}/bin/tar xjf "$fullpath" ;;
            *.tar.gz) ${pkgs.gnutar}/bin/tar xzf "$fullpath" ;;
            *.tar.xz) ${pkgs.gnutar}/bin/tar Jxvf "$fullpath" ;;
            *.tar.Z) ${pkgs.gnutar}/bin/tar xzf "$fullpath" ;;
            *.tar) ${pkgs.gnutar}/bin/tar xf "$fullpath" ;;
            *.taz) ${pkgs.gnutar}bin/tar xzf "$fullpath" ;;
            *.tb2) ${pkgs.gnutar}bin/tar xjf "$fullpath" ;;
            *.tbz) ${pkgs.gnutar}bin/tar xjf "$fullpath" ;;
            *.tbz2) ${pkgs.gnutar}bin/tar xjf "$fullpath" ;;
            *.tgz) ${pkgs.gnutar}bin/tar xzf "$fullpath" ;;
            *.txz) ${pkgs.gnutar}bin/tar Jxvf "$fullpath" ;;
            *.rar) ${pkgs.unrar}bin/unrar x "$fullpath" ;;
            *.zip) ${pkgs.unzip}/bin/unzip "$fullpath" ;;
            *.7z) ${pkgs.p7zip}/bin/7z x "$fullpath" ;;
            *) echo "'$1' cannot be extracted via extract()" && cd .. && ! $didfolderexist && rm -r "$foldername" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }
      man() {
        env \
          LESS_TERMCAP_mb=$(printf "\e[1;31m") \
          LESS_TERMCAP_md=$(printf "\e[1;31m") \
          LESS_TERMCAP_me=$(printf "\e[0m") \
          LESS_TERMCAP_se=$(printf "\e[0m") \
          LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
          LESS_TERMCAP_ue=$(printf "\e[0m") \
          LESS_TERMCAP_us=$(printf "\e[1;4;36m") \
          man "$@"
      }

      export FZF_DEFAULT_OPTS='--height 30% --layout=reverse --border'
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude ".git"'

      stty -ixon
    '';

    promptInit = ''
      function spaceship_nix_shell(){
        if [[ -n "$IN_NIX_SHELL" ]]; then
          spaceship::section "cyan" " nix"
        fi
      }

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
        nix_shell
      )

      autoload -U promptinit select-word-style && promptinit && prompt spaceship
    '';
  };
  environment.systemPackages = with pkgs; [zshThemes.spaceship];
  users.defaultUserShell = pkgs.zsh;
}

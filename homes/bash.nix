{ pkgs, ... }: {
  programs.bash = {
    enable = true;
    historySize = -1;
    historyFileSize = -1;
    shellOptions = [
      "checkwinsize"
      "globstar"
      "nocaseglob"
      "autocd"
      "dirspell"
      "cdspell"
      "histappend"
      "cmdhist"
    ];

    initExtra = ''
      HISTIGNORE="&:[ ]*:exit:l:ls:ll:bg:fg:history*:clear:kill*:?:??"

      set -o notify
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
      hm() {
        sed 's/[[:space:]]*$//' $HISTFILE | tac | awk '!x[$0]++' | tac | ${pkgs.moreutils}/bin/sponge $HISTFILE
      }
      stty -ixon
    '';
  };

  programs.fzf.enable = true;
  home.packages = with pkgs; [ fd ];

  programs.bat = {
    enable = true;
    config.theme = "OneHalfDark";
  };
}

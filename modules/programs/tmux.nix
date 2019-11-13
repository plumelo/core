{ config, options, lib, pkgs, ... }:
with pkgs.tmuxPlugins; {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    terminal = "tmux-256color";
    historyLimit = 10000;
    escapeTime = 0;
    keyMode = "vi";
    extraTmuxConf = ''
      # Automatically set window title
      set-window-option -g automatic-rename on
      set-option -g set-titles on
      set-option -g renumber-windows on
      set-window-option -g xterm-keys on
      set -g focus-events on
      setw -g mouse on
      setw -g monitor-activity on

      # colors
      set -ga terminal-overrides ",*col*:Tc"

      # prefix
      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      # Default colors
      set-option -g status-style fg=white,bg=black

      # Status
      set -g status-interval 1
      set -g status-justify left
      set -g status-left-length 40

      # Window titles
      set-window-option -g window-status-style fg=default,bg=default
      set-window-option -g window-status-current-style fg=white,bold,bg=default
      set-window-option -g window-status-activity-style fg=default,noreverse,bg=default

      # Bars
      set -g window-status-separator ""
      set -g status-left "#[fg=black,bg=blue,bold] #S #[fg=blue,bg=black,nobold,noitalics,nounderscore]"
      set -g status-right "#{prefix_highlight}#[fg=brightblack,bg=black,nobold,noitalics,nounderscore]#[fg=cyan,bg=brightblack] #[fg=black,bg=cyan,bold] #H "

      # Windows
      set -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#I #[fg=white,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#W #F #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
      set -g window-status-current-format "#[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#I #[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#W #F #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
      set -g window-status-separator ""

      # Panes
      set -g pane-border-style bg=default,fg=black
      set -g pane-active-border-style bg=default,fg=blue

      # tmux-prefix-highlight
      set -g @prefix_highlight_output_prefix "#[fg=brightcyan]#[bg=black]#[nobold]#[noitalics]#[nounderscore]#[bg=brightcyan]#[fg=black]"
      set -g @prefix_highlight_output_suffix ""
      set -g @prefix_highlight_copy_mode_attr "fg=brightcyan,bg=black,bold"

      set -g @resurrect-processes '\
        "~nvim->nvim" \
        "~tig->tig" \
        "~kak->kak" \
      '

      run-shell ${pain-control.rtp}
      run-shell ${sensible.rtp}
      run-shell ${resurrect.rtp}
      run-shell ${prefix-highlight.rtp}
    '';
  };
}

{ config, options, lib, pkgs, ... }:
with pkgs.tmuxPlugins; {
  programs.tmux = {
    baseIndex = 1;
    terminal = "tmux-256color";
    aggressiveResize = true;
    historyLimit = 500000;
    resizeAmount = 5;
    escapeTime = 0;
    extraConfig = ''
      bind | split-window -h -c "#{pane_current_path}"
      bind "\\" split-window -fh -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind "_" split-window -fv -c "#{pane_current_path}"
      bind "c" new-window -c "#{pane_current_path}"
      bind C-p previous-window
      bind C-n next-window
      bind h   select-pane -L
      bind C-h select-pane -L
      bind j   select-pane -D
      bind C-j select-pane -D
      bind k   select-pane -U
      bind C-k select-pane -U
      bind l   select-pane -R
      bind C-l select-pane -R
      bind -r "<" swap-window -d -t -1
      bind -r ">" swap-window -d -t +1
      bind -r K resize-pane -U 5
      bind -r J resize-pane -D 5
      bind -r H resize-pane -L 5
      bind -r L resize-pane -R 5

      set-window-option -g automatic-rename on
      set-option -g set-titles on
      set-option -g renumber-windows on
      set-window-option -g xterm-keys on
      set -g focus-events on
      setw -g mouse on
      setw -g monitor-activity on

      # colors
      set -ga terminal-overrides ",*col*:Tc"

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
      flash='#{?client_prefix,#[fg=magenta]#[fg=black]#[bg=magenta]#H,#[fg=cyan]#[bg=black]#[fg=black]#[bg=cyan]#H}'
      set -g status-right "$flash"

      # Windows
      set -g window-status-format "#[fg=black,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#I #[fg=white,bg=brightblack,nobold,noitalics,nounderscore] #[fg=white,bg=brightblack]#W #F #[fg=brightblack,bg=black,nobold,noitalics,nounderscore]"
      set -g window-status-current-format "#[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#I #[fg=black,bg=cyan,nobold,noitalics,nounderscore] #[fg=black,bg=cyan]#W #F #[fg=cyan,bg=black,nobold,noitalics,nounderscore]"
      set -g window-status-separator ""

      # Panes
      set -g pane-border-style bg=default,fg=black
      set -g pane-active-border-style bg=default,fg=blue
    '';
  };
}

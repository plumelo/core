{ config, options, lib, pkgs, ... }:
with pkgs.tmuxPlugins;
{
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

      set-window-option -g xterm-keys on
      set -ga terminal-overrides ",xterm-256color:Tc"

      set -g focus-events on

      setw -g mouse on
      setw -g monitor-activity on

      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix
      
      set -g @theme "one"
      set -g @theme-background "dark"

      set -g status-left-length 30
      set -g status-right '#{prefix_highlight}'

      run-shell ${pain-control.rtp}
      run-shell ${sensible.rtp}
      run-shell ${resurrect.rtp}
      run-shell ${tmux-theme.rtp}
      run-shell ${prefix-highlight.rtp}
    '';
  };
}

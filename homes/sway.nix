{ pkgs, config, lib, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  wayland.windowManager.sway.config = {
    menu = "bemenu-run -w -i --prefix '⇒' --prompt 'Run: ' --hb '#404654' --ff '#c698e3' --tf '#c698e3' --hf '#fcfcfc'";
    modifier = "Mod4";
    terminal = "alacritty";
    input."type:touchpad" = {
      dwt = "disabled";
      tap = "enabled";
      natural_scroll = "enabled";
      middle_emulation = "enabled";
    };
    gaps = {
      inner = 2;
      outer = 0;
      smartGaps = true;
    };
    window.hideEdgeBorders = "smart";
    keybindings = lib.mkOptionDefault {
      XF86AudioRaiseVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
      XF86AudioLowerVolume = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
      XF86AudioMute = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
      XF86MonBrightnessDown = "exec brightnessctl set 10%-";
      XF86MonBrightnessUp = "exec brightnessctl set +10%";
      Print = "exec slurp | grim -g - - | wl-copy";
      "Ctrl+Print" = "exec wf-recorder -f ~/record.mp4";
      "Ctrl+Shift+Print" = "exec wf-recorder -g \"$$(slurp)\" -f ~/record.mp4";
      "Ctrl+Shift+BackSpace" = "exec killall -s SIGINT wf-recorder";
      "Mod4+Control+l" = "exec loginctl lock-session";
    };
    fonts = [ "monospace 9" ];
    bars = [{
      mode = "dock";
      hiddenState = "hide";
      position = "bottom";
      fonts = [ "monospace 9" ];
      workspaceButtons = true;
      workspaceNumbers = true;
      statusCommand = "i3status-rs ~/.config/i3status-rust/config-bottom.toml";
      trayOutput = "primary";
      colors = {
        background = "#2E3440";
        statusline = "#839496";
        separator = "#777777";
        focusedWorkspace = {
          border = "#4C7899";
          background = "#285577";
          text = "#D8DEE9";
        };
        activeWorkspace = {
          border = "#333333";
          background = "#4C7899";
          text = "#D8DEE9";
        };
        inactiveWorkspace = {
          border = "#3B4252";
          background = "#2E3440";
          text = "#888888";
        };
        urgentWorkspace = {
          border = "#2F343A";
          background = "#900000";
          text = "#D8DEE9";
        };
        bindingMode = {
          border = "#2F343A";
          background = "#900000";
          text = "#D8DEE9";
        };
      };
    }];
    startup = [
      { command = "mako"; }
      {
        command = ''
          swayidle -w \
            timeout 300 '$lock' \
            timeout 600 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
            before-sleep '$lock' \
            lock '$lock'
        '';
      }
    ];
  };

  wayland.windowManager.sway.extraConfig = ''
    set $lock swaylock \
      --screenshots \
      --clock \
      --indicator \
      --indicator-radius 100 \
      --indicator-thickness 7 \
      --effect-blur 7x5 \
      --effect-vignette 0.5:0.5 \
      --ring-color 3b4252ff \
      --key-hl-color ebcb8bff \
      --inside-color 2e3440ff \
      --separator-color 3b4252ff \
      --grace 2 \
      --fade-in 0.2
  '';

  home.packages = with pkgs; [
    swaylock-effects
    swayidle
    wl-clipboard
    bemenu
    brightnessctl
    slurp
    grim
    lm_sensors
    pavucontrol
    wf-recorder
    killall
  ];

  programs.i3status-rust.enable = true;
  programs.i3status-rust.bars.bottom = {
    settings = {
      theme = "slick";
      overrides = {
        idle_bg = "#2e3440";
        idle_fg = "#839496";
        separator = "";

      };
    };
    icons = "awesome";
    blocks = [
      {
        block = "memory";
        display_type = "memory";
        format_mem = "{Mupi}%";
        format_swap = "{SUp}%";
      }
      {
        block = "cpu";
        format = "{utilization}% {frequency}";
      }
      {
        block = "temperature";
        collapsed = false;
        interval = 1;
        format = "{max}°";
        chip = "k10temp-*";
        idle = 70;
        info = 75;
        warning = 80;
      }
      {
        block = "sound";
        on_click = "pavucontrol";
      }
      {
        block = "networkmanager";
        on_click = "alacritty -e nmtui";
        interface_name_exclude = [ "br\\-[0-9a-f]{12}" "lxdbr\\d+" ];
      }
      {
        block = "time";
        interval = 60;
        format = "%a %d/%m %R";
      }
    ];
  };

  programs.mako = {
    enable = true;
    defaultTimeout = 10000;
    font = "sansSerif 9";
    backgroundColor = "#282c34";
    borderSize = 1;
    maxIconSize = 24;
  };

  services.wlsunset = {
    enable = true;
    latitude = "47.15";
    longitude = "27.59";
  };
}

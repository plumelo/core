{ pkgs, config, lib, ... }:
let
  fonts = { names = [ "monospace" ]; size = 9.00; };
  record = pkgs.writeShellScript "record" ''
    pid=`pgrep wf-recorder`
    status=$?
    if [ $status != 0 ]
    then
      area=$(slurp)
      wf-recorder -g "$area" -f ~/Screenshots/$(date +'recording_%Y-%m-%d-%H%M%S.mp4') -c h264_vaapi -d /dev/dri/renderD128 >/dev/null 2>&1 &
      notify-send "Recording started"
      pkill -RTMIN+8 i3status-rs
    else
      killall -s SIGINT wf-recorder
      notify-send "Recording stopped"
      wait $(pgrep wf-recorder)
      pkill -RTMIN+8 i3status-rs
    fi;
  '';
  bookmarks = pkgs.writeShellScript "bookmarks" ''
    exec cat ~/.sync/Docs/bookmarks | tofi --horizontal false --height 200 | xargs -0 -I {} echo "{}" | sed "s/#.*//"  | wtype - --
  '';
  bookmark = pkgs.writeShellScript "bookmark" ''
    tree=$(swaymsg -t 'get_tree')
    shell=$(echo $tree | ${pkgs.jq}/bin/jq -r 'recurse(.nodes[])|select(.focused == true)|.shell')
    if [ $shell == "xwayland" ]; then
      xdotool key ctrl+c
    else
      wtype -M ctrl c -m ctrl
    fi
    bookmark=$(wl-paste)
    title=$(echo $tree | ${pkgs.jq}/bin/jq -r 'recurse(.nodes[])|select(.focused == true)|.name' | sed 's/\s\-\s.*//')
    file=~/.sync/Docs/bookmarks
    if grep -q "^$bookmark #" "$file"; then
      notify-send "Bookmark already exists! $title"
    else
      notify-send "Bookmark added! $title # $bookmark"
      echo "$bookmark # $title" >> "$file"
    fi
    wl-copy -c
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    package = null;
  };
  wayland.windowManager.sway.config = {
    menu = "tofi-run | xargs swaymsg exec --";
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
      "Mod4+i" = "exec ${bookmarks}";
      "Mod4+Shift+i" = "exec ${bookmark}";
      Print = "exec slurp | grim -g - - | wl-copy";
      "Mod4+Print" = "exec ${record}";
      "Mod4+Control+l" = "exec loginctl lock-session";
    };
    inherit fonts;
    bars = [{
      mode = "dock";
      hiddenState = "hide";
      position = "bottom";
      inherit fonts;
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

    mode passthrough {
      bindsym Mod4+Y mode default
    }
    bindsym Mod4+Y mode passthrough
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
    wtype
    xdotool
  ];

  programs.i3status-rust.enable = true;
  programs.i3status-rust.bars.bottom = {
    settings = {
      theme.theme = "slick";
      overrides = {
        idle_bg = "#2e3440";
        idle_fg = "#839496";
        separator = "";
      };
    };
    icons = "awesome5";
    blocks = [
      {
        block = "custom";
        command = "pgrep wf-recorder > /dev/null && echo ''";
        interval = "once";
        signal = 8;
        hide_when_empty = true;
      }
      {
        block = "memory";
        format = " $icon $mem_used.eng(prefix:M) ($mem_used_percents.eng(w:2)) ";
        format_alt = " $icon_swap $swap_free.eng(w:3,u:B,p:M)/$swap_total.eng(w:3,u:B,p:M)($swap_used_percents.eng(w:2)) ";
      }
      {
        block = "cpu";
        format = " $icon $barchart $utilization ";
        format_alt = " $icon $frequency{ $boost|} ";
      }
      {
        block = "temperature";
        interval = 10;
        format = " $icon $max";
        chip = "k10temp-*";
        idle = 70;
        info = 75;
        warning = 80;
      }
      {
        block = "sound";
        click = [{
          button = "left";
          cmd = "pavucontrol";
        }];
      }
      {
        block = "net";
        format = " $icon $graph_down $graph_up {$signal_strength $ssid|$ip} via $device ";
        click = [{
          button = "left";
          cmd = "alacritty -e nmtui";
        }];
      }
      {
        block = "time";
        interval = 60;
        format = {
          full = " $icon $timestamp.datetime(f:'%a %Y-%m-%d %R', l:ro_RO) ";
          short = " $icon $timestamp.datetime(f:%R) ";
        };
      }
    ];
  };

  services.mako = {
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

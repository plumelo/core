{
  pkgs,
  config,
  lib,
  ...
}:
let
  fonts = {
    names = [ "monospace" ];
    size = 9.00;
  };
  record = pkgs.writeShellScript "record" ''
    args="$@"
    pid=`pgrep wf-recorder`
    status=$?
    if [ $status != 0 ]
    then
      area=$(slurp)
      wf-recorder -g "$area" $args -f ~/Screenshots/$(date +'recording_%Y-%m-%d-%H%M%S.mp4') -c h264_vaapi -d /dev/dri/renderD128 >/dev/null 2>&1 &
      notify-send "Recording started"
    else
      killall -s SIGINT wf-recorder
      notify-send "Recording stopped"
      wait $(pgrep wf-recorder)
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
    window.titlebar = false;
    keybindings =
      let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in
      lib.mkOptionDefault {
        XF86AudioRaiseVolume = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 0.05+";
        XF86AudioLowerVolume = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
        XF86AudioMute = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        XF86MonBrightnessDown = "exec brightnessctl set 10%-";
        XF86MonBrightnessUp = "exec brightnessctl set +10%";
        XF86AudioPlay = "exec playerctl play-pause";
        XF86AudioPause = "exec playerctl play-pause";
        XF86AudioNext = "exec playerctl next";
        XF86AudioPrev = "exec playerctl previous";
        XF86AudioStop = "exec playerctl stop";
        "${modifier}+i" = "exec ${bookmarks}";
        "${modifier}+Shift+i" = "exec ${bookmark}";
        Print = "exec slurp | grim -g - - | wl-copy";
        "Mod4+Print" = "exec ${record}";
        "Mod4+Shift+Print" = "exec ${record} -a";
        "Mod4+Control+l" = "exec loginctl lock-session";
      };
    inherit fonts;
    bars = [ ];
    startup = [
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
      --ring-color 44475aff \
      --key-hl-color bd93f9ff \
      --inside-color 282a36ff \
      --separator-color 44475aff \
      --grace 2 \
      --fade-in 0.2

    mode passthrough {
      bindsym Mod4+Y mode default
    }
    bindsym Mod4+Y mode passthrough

    for_window [shell=".*"] inhibit_idle fullscreen
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

  services.wlsunset = {
    enable = true;
    latitude = "47.15";
    longitude = "27.59";
  };

  services.swaync = {
    enable = true;
    style =
      with pkgs;
      runCommandLocal "swaync-style.css"
        {
          style = fetchurl {
            url = "https://raw.githubusercontent.com/dracula/swaync/main/style.css";
            hash = "sha256-hwZuIR8NOvcE4u03WcALCdlzHNyVY42OGE81JOVM0Ww=";
          };
        }
        ''
          cat $style > $out
          sed -i 's|/\* font-family: "JetBrainsMono Nerd Font", sans-serif; \*/|font-family: "DejaVuSansMono Nerd Font", sans-serif;|' $out
          cat >> $out <<'OVERRIDES'
* { font-size: 12px; }
.widget-title > label { font-size: 13px; }
.widget-title button { padding: 3px 8px; }
.widget-dnd, .widget-inhibitors { font-size: 12px; }
.widget-buttons-grid > flowbox > flowboxchild > button { padding: 4px 0; }
OVERRIDES
        '';

  };
}

{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.sway;
in
{

  options.programs.sway = {
    extraConfig = mkOption {
      type = types.lines;
      default = "";
    };

    terminal = mkOption {
      type = types.str;
      default = "${pkgs.alacritty}/bin/alacritty";
    };

    menu = mkOption {
      type = types.str;
      default = "${pkgs.bemenu}/bin/bemenu-run -i --prompt '▶' --tf '#3daee9' --hf '#3daee9' --sf '#3daee9' --scf '#3daee9'";
    };

    status = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {

    programs.sway = {
      extraPackages = (with pkgs; [
        glib
        paper-icon-theme
        nordic
        xwayland
        android-udev-rules
        jmtpfs
        xdg_utils
        wl-clipboard
        lm_sensors
      ]);
      extraSessionCommands = ''
        export XKB_DEFAULT_LAYOUT=us
        export XDG_DATA_DIRS=${
          let schema = pkgs.gsettings-desktop-schemas;
            in "${schema}/share/gsettings-schemas/${schema.name}"
        }:$XDG_DATA_DIRS
      '';
    };

    users.defaultUser.extraGroups = [ "sway" ];
    networking.networkmanager.enable = true;

    services.upower.enable = true;
    services.udev.packages = with pkgs; [ brightnessctl android-udev-rules ];

    environment.etc."sway/config".text = with pkgs; ''
      include "${sway}/etc/sway/config"

      set $swaylock ${swaylock}/bin/swaylock
      set $brightness ${brightnessctl}/bin/brightnessctl
      set $grim ${grim}/bin/grim
      set $mogrify ${imagemagick}/bin/mogrify
      set $slurp ${slurp}/bin/slurp
      set $mako ${mako}/bin/mako
      set $idle ${swayidle}/bin/swayidle
      set $lock $grim /tmp/lock.png && $mogrify -scale 10% -scale 1000% /tmp/lock.png && $swaylock -f -i /tmp/lock.png
      set $menu ${cfg.menu}
      set $term ${cfg.terminal}

      # input
      input "2:14:ETPS/2_Elantech_Touchpad" {
        dwt enabled
        tap enabled
        natural_scroll enabled
        middle_emulation enabled
      }
      input "1267:12433:ELAN0504:01_04F3:3091_Touchpad" {
        dwt enabled
        tap enabled
        natural_scroll enabled
        middle_emulation enabled
      }

      # Basics:
      bindsym --no-warn $mod+Return exec $term
      bindsym --no-warn $mod+d exec $menu
      bindsym --no-warn $mod+Shift+e exit

      bindsym $mod+Tab workspace back_and_forth

      # Audio
      bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86MonBrightnessDown exec $brightness set 10%-
      bindsym XF86MonBrightnessUp exec $brightness set +10%

      bindsym Print exec $slurp | $grim -g - - | wl-copy

      bindsym --release $mod+Control+l exec loginctl lock-session
      exec $idle -w \
        timeout 300 '$lock' \
        timeout 600 'swaymsg "output * dpms off"' \
          resume 'swaymsg "output * dpms on"' \
        before-sleep '$lock' \
        lock '$lock'

      gaps inner 2
      gaps outer 0
      smart_gaps on
      hide_edge_borders smart
      default_border pixel 1
      default_floating_border pixel 1

      font pango: monospace 9

      # Status Bar:
      bar bar-0 position bottom
      bar bar-0 font pango: monospace 9
      bar bar-0 mode dock
      bar bar-0 modifier none
      bindsym $mod+m bar mode toggle
      bar bar-0 colors {
        background #2E3440
        statusline #839496
        separator  #777777

        focused_workspace  #4C7899 #285577 #D8DEE9
        active_workspace   #333333 #4C7899 #D8DEE9
        inactive_workspace #3B4252 #2E3440 #888888
        urgent_workspace   #2F343A #900000 #D8DEE9
        binding_mode       #2F343A #900000 #D8DEE9
      }

      exec --no-startup-id $mako --default-timeout=10000 \
        --font='sansSerif 9' \
        --background-color=#282c34 \
        --border-size=0 \
        --border-color=#0059a3 \
        --max-icon-size=20

      set $gnome-schema org.gnome.desktop.interface
      exec_always {
        gsettings set $gnome-schema gtk-theme 'Nordic-bluish-accent'
        gsettings set $gnome-schema icon-theme 'Paper'
      }

      mode passthrough {
        bindsym $mod+Pause mode default
      }
      bindsym $mod+Pause mode passthrough

      ${ if (cfg.status != null) then "bar bar-0 status_command ${cfg.status}" else "" }
      ${cfg.extraConfig}
    '';
  };
}

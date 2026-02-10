{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 20;
        font-size = 9;
        modules-left = [
          "sway/workspaces"
        ];
        modules-center = [
          "custom/notification"
          "custom/recording"
        ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "pulseaudio#mic"
          "group/network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "clock"
          "tray"
        ];
        tray = {
          spacing = 8;
          show-passive-items = true;
        };
        "custom/recording" = {
          exec = ''
            pgrep wf-recorder >/dev/null && echo " REC ●" || echo ""
          '';
          interval = 1;
          format = "{}";
          hide-on-empty = true;
          tooltip = false;
          on-click = null;
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon}";
          format-muted = "󰖁 ";
          format-icons = {
            headphone = "";
            default = [
              ""
              ""
              ""
            ];
          };
          scroll-step = 5;
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "pulseaudio#mic" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 5%+";
          on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          scroll-step = 5;
          tooltip = false;
        };
        "group/network" = {
          modules = [
            "network"
            "network#wireguard"
          ];
          orientation = "inherit";
        };
        network = {
          format-disconnected = "";
          format-ethernet = "󰈀 ";
          format-wifi = "{icon} {essid}";
          format-icons = [
            "󰤟 "
            "󰤢 "
            "󰤥 "
            "󰤨 "
          ];
          tooltip-format = "{ifname}\n{ipaddr}\n{essid} ({signalStrength}%)";
          on-click = "alacritty --command nmtui";
        };
        "network#wireguard" = {
          interface = "wg0";
          interval = 3;
          format-disabled = "◍";
          format = "◉";
          tooltip-format = "Wireguard IP:{ipaddr} GW:{gwaddr} NM:{netmask} {bandwidthDownBytes} {bandwidthUpBytes}";
          tooltip-format-disabled = "▾ Wireguard down.";
        };
        cpu = {
          format = " {usage:>2}% {max_frequency}GHz";
        };
        memory = {
          format = " {used:0.1f}GB";
          tooltip-format = "{used:0.1f}GiB used, {swapUsed:0.1f}GiB swap";
        };
        clock = {
          format = "{:%I:%M %p}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
          actions = {
            "on-scroll-up" = "shift_up";
            "on-scroll-down" = "shift_down";
          };
        };
        "custom/notification" = {
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          return-type = "json";
          format = " {icon} ";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          escape = true;
          format-icons = {
            notification = "󰂚";
            none = "󰂜";
            dnd-notification = "󰂛";
            dnd-none = "󰪑";
            inhibited-notification = "󰂛";
            inhibited-none = "󰪑";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰪑";
          };
        };
      };
    };
  };
}

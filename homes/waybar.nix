{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 0;
        font-size = 9;
        modules-left = [
          "sway/workspaces"
        ];
        modules-center = [
          "custom/notification"
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
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon}";
          format-muted = "󰖁 ";
          format-icons = {
            headphone = "";
            default = [
              ""
              ""
              ""
            ];
          };
          scroll-step = 5;
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "pulseaudio#mic" = {
          format = "{format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
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
          format-disconnected = "";
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
          tooltip-format = "Wireguard IP:{ipaddr} GW:{gwaddr} NM:{netmask} {bandwidthDownBytes} {bandwidthUpBytes}";
          tooltip-format-disabled = "▾ Wireguard down.";
        };
        cpu = {
          format = " {usage:>2}% {max_frequency}GHz";
        };
        memory = {
          format = " {used:0.1f}GB";
          tooltip-format = "{used:0.1f}GiB used, {swapUsed:0.1f}GiB swap";
        };
        temperature = {
          hwmon-name = "k10temp";
          input-filename = "temp1_input";
          critical-threshold = 80;
          interval = 2;
          format = "{temperatureC}°C ";
          format-critical = "{temperatureC}°C ";
          tooltip = false;
        };
        battery = {
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          states = {
            warning = 30;
            critical = 15;
          };
          tooltip-format = "{timeTo} remaining";
        };
        clock = {
          interval = 60;
          format = "{:%a %Y-%m-%d %R}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            format = {
              months = "<span color='#F1FA8C'><b>{}</b></span>";
              weekdays = "<span color='#8BE9FD'><b>{}</b></span>";
              today = "<span color='#FF5555'><b><u>{}</u></b></span>";
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
    style = ''
      * {
        all: unset;
        font-family: "DejaVuSansMono Nerd Font";
        font-size: 12px;
        min-height: 16px;
        padding: 1px 0;
      }

      window#waybar {
        background-color: #282A36;
        color: #F8F8F2;
      }

      #workspaces button {
        padding: 0 6px;
        color: #6272A4;
      }

      #workspaces button.focused {
        color: #BD93F9;
        font-weight: bold;
      }

      #workspaces button.visible {
        color: #8BE9FD;
      }

      #workspaces button.urgent {
        color: #FF5555;
        font-weight: bold;
      }

      #cpu, #memory, #temperature, #battery, #clock, #pulseaudio,
      #network, #custom-notification, #idle_inhibitor, #tray {
        padding: 0 8px;
      }

      #clock {
        color: #8BE9FD;
        font-weight: bold;
      }

      #pulseaudio {
        color: #50FA7B;
      }

      #pulseaudio.muted {
        color: #6272A4;
      }

      #battery {
        color: #50FA7B;
      }

      #battery.charging {
        color: #8BE9FD;
      }

      #battery.warning {
        color: #F1FA8C;
      }

      #battery.critical {
        color: #FF5555;
      }

      #network {
        color: #FFB86C;
      }

      #network.disconnected {
        color: #FF5555;
      }

      #cpu {
        color: #FF79C6;
      }

      #memory {
        color: #FF79C6;
      }

      #temperature {
        color: #FFB86C;
      }

      #temperature.critical {
        color: #FF5555;
      }

      #custom-notification {
        color: #8BE9FD;
      }

      #idle_inhibitor {
        color: #F1FA8C;
      }

      #tray {
        padding: 0 8px;
      }

      #tray > .needs-attention {
        background-color: #FF5555;
      }

      tooltip {
        background-color: #282A36;
        border: 1px solid #44475A;
        border-radius: 8px;
        padding: 6px 10px;
      }
    '';
  };
}
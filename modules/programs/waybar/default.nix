{ config, lib, pkgs, ... }:
let cfg = config.programs.waybar;
in {
  config = {
    environment.etc."xdg/waybar/config".text = with pkgs; ''
      {
        "layer": "bottom",
          "position": "bottom",
          "height": 22,
          "modules-left": [
            "sway/workspaces",
            "sway/mode"
          ],
          "modules-center": [
            "clock"
          ],
          "modules-right": [
            "network",
            "cpu",
            "temperature#cpu",
            "temperature#gpu",
            "memory",
            "pulseaudio",
            "battery",
            "tray"
          ],
          "sway/workspaces": {
            "all-outputs": false,
            "format": "{name}"
          },
          "sway/mode": {
            "format": "<span style=\"italic\">{}</span>"
          },
          "network": {
            "format": "{icon}",
            "format-alt": "{ipaddr}/{cidr} {icon}",
            "format-alt-click": "click-right",
            "format-icons": {
              "wifi": ["", "" ,""],
              "ethernet": [""],
              "disconnected": [""]
            },
            "tooltip": false
          },
          "clock": {
            "interval": 60,
            "format": "{:%a %d %B %H:%M}",
            "max-length": 25,
            "tooltip": false
          },
          "cpu": {
            "interval": 10,
            "format": "{}% ",
            "max-length": 10
          },
          "temperature#cpu": {
            "thermal-zone": 1,
            "hwmon-path": "/sys/class/hwmon/hwmon0/temp1_input",
            "critical-threshold": 80,
            "format-critical": "{temperatureC}°C ",
            "format": "{temperatureC}°C "
          },
          "temperature#gpu": {
            "thermal-zone": 2,
            "hwmon-path": "/sys/class/hwmon/hwmon1/temp1_input",
            "critical-threshold": 80,
            "format-critical": "{temperatureC}°C ",
            "format": "{temperatureC}°C "
          },
          "memory": {
            "format": "{}% "
          },
          "battery": {
            "bat": "BAT1",
            "interval": 60,
            "states": {
              "warning": 40,
              "critical": 20
            },
            "format": "{capacity}% {icon}",
            "format-icons": ["", "", "", "", ""],
            "max-length": 25
          },
          "tray": {
            "spacing": 10
          },
          "pulseaudio": {
            "format": "{volume}% {icon}",
            "format-muted": "🔇",
            "format-icons": {
              "default": ["🔈", "🔊"]
            },
            "scroll-step": 5,
            "on-click-right": "pactl set-sink-mute 0 toggle",
            "tooltip": false
          }
      }
    '';
    environment.etc."xdg/waybar/style.css".text = with pkgs; ''
      * {
        border: none;
        border-radius: 0;
        font-family: "SauceCodePro Nerd Font";
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background: #282c34;
        color: #bcd1d6;
      }

      #workspaces button {
        padding: 0 8px;
        color: #ffffff;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        background: #282c34;
        border: #282c34;
        padding: 0 8px;
      }

      #workspaces button.focused {
        background: #00427a;
        color: #ffffff;
      }

      #mode, #pulseaudio, #cpu, #temperature.cpu, #temperature.gpu, #memory, #network, #tray {
        color: #dce5d0;
        padding: 0 5px;
        margin: 0 0 0 5px;
      }

      #battery {
        color: #e5c07b;
      }

      #battery.charging {
        color: #26A65B;
      }

      #battery.warning,
      #batter.critical
      {
        color: #f53c3c;
      }

      @keyframes blink {
        to {
          color: #282c34;
        }
      }

      #battery.critical:not(.charging) {
        color: #f53c3c;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #tray {
        background: #00427a;
      }
    '';
  };
}

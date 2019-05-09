{alacritty}:
# vim: set syntax=json:
''
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
      "backlight",
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
      "on-click": "${alacritty}/bin/alacritty --title 'nmtui' -e nmtui",
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
      "bat": "BAT2",
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
      "on-click": "pavucontrol",
      "on-click-right": "pactl set-sink-mute 0 toggle",
      "tooltip": false
    }
}
''

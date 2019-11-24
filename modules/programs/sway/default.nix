{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.sway;
in {

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
      default = "${pkgs.wofi}/bin/wofi -i -m";
    };

    status = mkOption {
      type = types.str;
      default = "${pkgs.waybar.override { pulseSupport = true; }}/bin/waybar";
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
      set $swaylock ${swaylock}/bin/swaylock
      set $term ${cfg.terminal}
      set $skim ${skim}/bin/sk
      set $brightness ${brightnessctl}/bin/brightnessctl
      set $grim ${grim}/bin/grim
      set $mogrify ${imagemagick}/bin/mogrify
      set $slurp ${slurp}/bin/slurp
      set $mako ${mako}/bin/mako
      set $idle ${swayidle}/bin/swayidle
      set $lock $grim /tmp/lock.png && $mogrify -scale 10% -scale 1000% /tmp/lock.png && $swaylock -f -i /tmp/lock.png
      set $menu ${cfg.menu}
      set $status ${cfg.status}

      ${builtins.readFile ./config}

      ${cfg.extraConfig}
    '';
  };
}

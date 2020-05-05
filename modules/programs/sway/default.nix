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
      default = "${pkgs.bemenu}/bin/bemenu-run --prompt '▶' --tf '#3daee9' --hf '#3daee9' --sf '#3daee9' --scf '#3daee9'";
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

      ${builtins.readFile ./config}

      ${
        if (cfg.status != null) then
            "bar bar-0 status_command ${cfg.status}"
        else ""
      }
      ${cfg.extraConfig}
    '';
  };
}

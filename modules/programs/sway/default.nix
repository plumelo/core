{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.sway;
  waybar = pkgs.waybar;
  waybarConfig =
  pkgs.writeText "config" (pkgs.callPackage ./waybar-config.nix { });
  waybarStyle = pkgs.writeText "config" (builtins.readFile ./waybar.css);
in {

  options.programs.sway = {
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
    };

    terminal = lib.mkOption {
      type = lib.types.string;
      default = "${pkgs.alacritty}/bin/alacritty";
    };

    menu = lib.mkOption {
      type = lib.types.string;
      default =
      "$term --title 'fzf-menu' -e bash -c '${pkgs.dmenu}/bin/dmenu_path | sort -u | $fzf | xargs -I ? -r swaymsg exec ?'";
    };

  };

  config = mkIf cfg.enable {

    programs.sway = {
      extraPackages = (with pkgs; [
        arc-theme
        arc-icon-theme
        paper-icon-theme
        xwayland
        android-udev-rules
        jmtpfs
        xdg_utils
        wl-clipboard
      ]);
      extraSessionCommands = ''
        export XKB_DEFAULT_LAYOUT=us
      '';
    };

    users.defaultUser.extraGroups = [ "sway" ];
    networking.networkmanager.enable = true;

    fonts.fonts = with pkgs; [ overpass nerdfonts ];

    services.upower.enable = true;
    services.udev.packages = with pkgs; [ brightnessctl android-udev-rules ];

    environment.etc."sway/config".text = with pkgs; ''
      set $swaylock ${swaylock}/bin/swaylock
      set $term ${cfg.terminal}
      set $fzf ${fzf}/bin/fzf
      set $brightness ${brightnessctl}/bin/brightnessctl
      set $grim ${grim}/bin/grim
      set $mogrify ${imagemagick}/bin/mogrify
      set $slurp ${slurp}/bin/slurp
      set $mako ${mako}/bin/mako
      set $idle ${swayidle}/bin/swayidle
      set $lock $grim /tmp/lock.png && $mogrify -scale 10% -scale 1000% /tmp/lock.png && $swaylock -f -i /tmp/lock.png

      set $menu ${cfg.menu}

      set $status ${waybar}/bin/waybar

      output * bg ${./wallpaper.jpg} fill
      output "Goldstar Company Ltd LG ULTRAWIDE 0x0000B7AA" bg ${
        ./wallpaper_2560x1080.jpg
      } fill
      output "Goldstar Company Ltd LG ULTRAWIDE 0x0000C708" bg ${
        ./wallpaper_2560x1080.jpg
      } fill
      output "Dell Inc. DELL U2515H 9X2VY74E0FFL" bg ${
        ./wallpaper_2560x1080.jpg
      } fill
      output "Dell Inc. DELL U2518D 3C4YP773ARUL" bg ${
        ./wallpaper_2560x1080.jpg
      } fill

      ${builtins.readFile ./config}

      exec ${tmux}/bin/tmux start-server \; run-shell ${tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh
      ${cfg.extraConfig}
    '';
  };
}

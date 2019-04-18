{ config, lib, pkgs, ... }:
let
  ldLibraryPath = config.environment.sessionVariables.LD_LIBRARY_PATH;
  i3status-rust = pkgs.i3status-rust;
  i3status-rustconf = pkgs.writeText "i3status-config.toml" ''
    theme = "modern"
    icons = "awesome"

    [[block]]
    block = "memory"
    display_type = "memory"
    format_mem = "{Mup}%"
    format_swap = "{SUp}%"

    [[block]]
    block = "cpu"
    interval = 1

    [[block]]
    block = "temperature"
    collapsed = false
    interval = 10
    format = "{average}°"

    [[block]]
    block = "sound"

    [[block]]
    block = "time"
    interval = 60
    format = "%a %d/%m %R"
  '';
swayPackage = pkgs.sway;
swayWrapped = pkgs.writeShellScriptBin "sway" ''
    export XKB_DEFAULT_LAYOUT=us
    if [[ "$#" -ge 1 ]]; then
      exec sway-setcap "$@" -c /etc/sway/config
    else
      exec ${pkgs.dbus.dbus-launch} --exit-with-session sway-setcap -c /etc/sway/config
    fi
'';
  swayJoined = pkgs.symlinkJoin {
    name = "sway-joined";
    paths = [ swayWrapped swayPackage ];
  };

in {
  environment.systemPackages = [
    swayJoined
    ]++ (with pkgs;[
    arc-theme
    arc-icon-theme
    paper-icon-theme
    xwayland
    android-udev-rules
    jmtpfs
    xdg_utils
    lm_sensors
  ]);
  security.wrappers.sway = {
    program = "sway-setcap";
    source = "${swayPackage}/bin/sway";
    capabilities = "cap_sys_ptrace,cap_sys_tty_config=eip";
    owner = "root";
    group = "sway";
    permissions = "u+rx,g+rx";
  };

  users.groups.sway = {};
  security.pam.services.swaylock = {};

  fonts.enableDefaultFonts = lib.mkDefault true;
  programs.dconf.enable = lib.mkDefault true;

  boot.kernel.sysctl."fs.inotify.max_user_watches" = lib.mkDefault 524288;

  networking.networkmanager.enable = true;

  hardware.opengl.enable = true;
  programs.ssh.startAgent = true;

  fonts.fonts = with pkgs; [nerdfonts];

  services.upower.enable = true;
  services.udev.packages = with pkgs; [
    brightnessctl
    android-udev-rules
  ];

  environment.etc."sway/config".text = with pkgs; ''
    set $shell LD_LIBRARY_PATH=${ldLibraryPath} ${pkgs.zsh}/bin/zsh
    set $swaylock ${swaylock}/bin/swaylock
    set $term ${alacritty}/bin/alacritty
    set $fzf ${fzf}/bin/fzf
    set $brightness ${brightnessctl}/bin/brightnessctl
    set $grim ${grim}/bin/grim
    set $mogrify ${imagemagick}/bin/mogrify
    set $slurp ${slurp}/bin/slurp
    set $xclip ${xclip}/bin/xclip
    set $mako ${mako}/bin/mako

    set $menu $term --title "fzf-menu" -e bash -c '${dmenu}/bin/dmenu_path | sort -u | $fzf | xargs -I ? -r swaymsg exec "$shell -c ?"'

    set $status ${i3status-rust}/bin/i3status-rs ${i3status-rustconf}

    output * bg ${./wallpaper.jpg} fill
    output "Goldstar Company Ltd LG ULTRAWIDE 0x0000B7AA" bg ${./wallpaper_2560x1080.jpg} fill
    output "Goldstar Company Ltd LG ULTRAWIDE 0x0000C708" bg ${./wallpaper_2560x1080.jpg} fill
    output "Dell Inc. DELL U2515H 9X2VY74E0FFL" bg ${./wallpaper_2560x1080.jpg} fill
    output "Dell Inc. DELL U2518D 3C4YP773ARUL" bg ${./wallpaper_2560x1080.jpg} fill

    ${builtins.readFile ./config}

    exec ${tmux}/bin/tmux start-server \; run-shell ${tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh
  '';

}

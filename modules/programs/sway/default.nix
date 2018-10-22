{ config, lib, pkgs, ... }:
let i3blocksconf = with pkgs; writeText "i3blocksconf" ''
  command=${i3blocks}/libexec/i3blocks/$BLOCK_NAME
  separator_block_width=15
  markup=none
  color=#E0E0E0

  [memory]
  label=MEM
  separator=false
  interval=5

  [temperature]
  command=${i3blocks}/libexec/i3blocks/temperature -w 80 -c 90
  label=
  interval=1

  [volume]
  label=
  interval=1

  [battery]
  label=⚡
  interval=5

  [date]
  command=date '+%b %d %H:%M'
  interval=60
  label=
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

  environment.etc."sway/config".text = with pkgs;''
    set $term ${alacritty}/bin/alacritty
    set $fzf ${fzf}/bin/fzf
    set $brightness ${brightnessctl}/bin/brightnessctl
    set $grim ${grim}/bin/grim
    set $mogrify ${imagemagick}/bin/mogrify
    set $slurp ${slurp}/bin/slurp
    set $xclip ${xclip}/bin/xclip
    set $mako ${mako}
    set $i3blocks ${i3blocks}/bin/i3blocks
    set $i3blocksconf ${i3blocksconf} 

    output * bg ${./wallpaper.jpg} fill
    output "Goldstar Company Ltd LG ULTRAWIDE 0x0000B7AA" bg ${./wallpaper_2560x1080.jpg} fill

    ${builtins.readFile ./config} 

    include ${sway}/etc/sway/config.d/*

  '';

}

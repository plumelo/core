{ config, options, lib, pkgs, ... }: {
  imports = [
    ./pkgs.nix
    ./users.nix
    ./programs/bash
    ./programs/tmux.nix
    ./programs/git
    ./programs/ssh
    ./programs/lf
    ./virtualisation/lxc.nix
    ./virtualisation/lxd.nix
    ./virtualisation/virtualbox.nix
    ./virtualisation/wine.nix
    ./services/redshift
    ./services/networking/syncthing.nix
    ./programs/sway
    ./programs/waybar
  ];

  system.stateVersion = "20.03";

  i18n = { defaultLocale = "en_US.UTF-8"; };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  time.timeZone = "Europe/Bucharest";

  hardware = {
    pulseaudio.enable = true;
    cpu.amd.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
  };

  boot = {
    initrd.availableKernelModules = [ "hid-logitech-hidpp" ];

    kernel.sysctl."fs.inotify.max_user_watches" = lib.mkDefault 524288;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.ntp.enable = true;

  networking.networkmanager = { dns = "dnsmasq"; };
}

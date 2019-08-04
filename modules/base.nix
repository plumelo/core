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
    ./hardware/ssd.nix
    ./hardware/zram.nix
    ./services/redshift
    ./services/networking/syncthing.nix
    ./programs/sway
    ./programs/waybar
  ];

  system.stateVersion = "19.03";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
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


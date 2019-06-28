{ config, options, lib, pkgs, ... }:
{
  imports = [
    ./pkgs.nix
    ./programs/bash/default.nix
    ./programs/tmux.nix
    ./programs/git
    ./programs/ssh
    ./programs/lf/default.nix
    ./virtualisation/lxc.nix
    ./virtualisation/lxd.nix
    ./virtualisation/virtualbox.nix
    ./hardware/ssd.nix
    ./hardware/zram.nix
    ./users.nix
    ./services/redshift/default.nix
  ];

  system.stateVersion = "19.03";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Bucharest";


  programs = {
    java.enable = true;
  };

  hardware = {
    pulseaudio.enable = true;
    cpu.amd.updateMicrocode = true;
    opengl.extraPackages = with pkgs; [
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  boot = {
    initrd.availableKernelModules = [
      "hid-logitech-hidpp"
    ];

    kernel.sysctl."fs.inotify.max_user_watches" = lib.mkDefault 524288;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.ntp.enable = true;

  networking.networkmanager = {
    dns = "dnsmasq";
  };
}


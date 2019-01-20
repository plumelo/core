{ config, options, lib, pkgs, ... }:
# TO DO: move more of this into separate 
let local = ../local.nix;
in
{
  imports = (if builtins.pathExists local then [local] else []) ++
  [
    ./pkgs.nix
    ./programs/tmux.nix
    ./virtualisation/lxc.nix
    ./virtualisation/lxd.nix
    ./hardware/ssd.nix
    ./hardware/zram.nix
    ./users.nix
  ];


  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Bucharest";

  powerManagement = {
    enable = true;
  };

  programs = {
    fish.enable = true;
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
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.ntp.enable = true;
}


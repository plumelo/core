{ config, lib, pkgs, ... }:
{
  imports = [
    # all new pkgs and/or overlays
    ../pkgs/all.nix

    # config
    ../modules/virtualisation/lxc.nix
    ../modules/virtualisation/lxd.nix
    ../modules/hardware/ssd.nix
    ../modules/hardware/zram.nix
  ];

  nix.buildCores = 0;
  nixpkgs.config.allowUnfree = true;

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
    tmux.enable = true;
    fish.enable = true;
    java.enable = true;
  };

  hardware = {
    pulseaudio.enable = true;

    cpu.intel.updateMicrocode = true;
    cpu.amd.updateMicrocode = true;

    opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
  };

  boot = {
    initrd.availableKernelModules = [
      "hid-logitech-hidpp"
    ];
    kernelModules = [
      "coretemp"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = ["ideapad-laptop"];
  };

  users.defaultUserShell = "/run/current-system/sw/bin/fish";
  
  environment.systemPackages = with pkgs; [
    # common
    acl
    tree
    wget
    xsel
    p7zip
    lm_sensors
  ];
  
  services.ntp.enable = true;
}

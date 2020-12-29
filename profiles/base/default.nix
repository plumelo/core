{ lib, pkgs, ... }: {

  time.timeZone = "Europe/Bucharest";

  location = {
    latitude = 47.15;
    longitude = 27.59;
  };

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}

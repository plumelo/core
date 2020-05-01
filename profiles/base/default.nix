{ lib, pkgs, ... }: {

  i18n = { defaultLocale = "en_US.UTF-8"; };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

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

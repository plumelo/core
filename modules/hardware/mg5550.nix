{ config, lib, pkgs, ... }:
{

  services.printing = {
    enable = true;
    drivers = with pkgs; [gutenprint];
  };

  hardware.sane.enable = true;
  environment.systemPackages = with pkgs; [
    gnome3.simple-scan
  ];
  users.defaultUser.extraGroups = [
    "scanner"
    "lp"
  ];
}

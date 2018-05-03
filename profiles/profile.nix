{ config, lib, pkgs, ... }:
{
  imports = [
    ./local.nix
    ./plumelo.nix
    ../modules/services/X11/gnome3.nix
  ];
  boot = {
    kernelModules  = [
      "nct6775"
    ];
    kernelPackages = pkgs.linuxPackagesFor pkgs.linux_testing_plumelo;
  };
}

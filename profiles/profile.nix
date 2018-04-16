{ config, lib, pkgs, ... }:
{
  imports = [
    ./local.nix
    ./plumelo.nix
    ../modules/services/X11/gnome3.nix
  ];

  nix.buildCores = 10;
  boot = {
    kernelModules  = [
      "nct6775"
    ];
    kernelPackages = pkgs.linux_4_16;
  };
}

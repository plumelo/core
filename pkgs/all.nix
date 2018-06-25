{ config, lib, pkgs, ... }:
{
  imports = [
    ./linux/linux-4.18.nix
    ./linux/it87.nix
    ./lm-sensors/lm-sensors.nix
  ];
}

{ config, lib, pkgs, ... }:
{
  imports = [
    ./linux/firmware.nix
    ./linux/kernel.nix
    ./brightnessctl/default.nix
    ./lm-sensors/lm-sensors.nix
  ];
}

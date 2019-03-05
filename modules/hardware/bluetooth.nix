{ config, lib, pkgs, ... }:
{
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  environment.systemPackages = with pkgs; [blueman];
}

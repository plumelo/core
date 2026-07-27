{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.virtualisation.wine;
  winePackage = pkgs.wineWowPackages.staging;
in
{
  options = {
    virtualisation.wine = { enable = mkEnableOption "Enable Wine"; };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      winePackage
      winetricks
    ];
    hardware.graphics.enable32Bit = true;
    services.pulseaudio.support32Bit = true;
  };
}

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
      (winetricks.override { wine = winePackage; })
    ];
    hardware.opengl.driSupport32Bit = true;
    hardware.pulseaudio.support32Bit = true;
  };
}

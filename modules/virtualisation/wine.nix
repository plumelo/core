{ config, lib, pkgs, ... }:
with lib;
let cfg = config.virtualisation.wine;
in {
  options = {
    virtualisation.wine = { enable = mkEnableOption "Enable Wine"; };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wineStaging
      (winetricks.override { wine = wineStaging; })
    ];
    hardware.opengl.driSupport32Bit = true;
    hardware.pulseaudio.support32Bit = true;
  };
}

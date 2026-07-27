{ config, lib, pkgs, ... }:
with lib;
let cfg = config.hardware.bluetooth;
in
{
  config = mkIf cfg.enable {
    services.pulseaudio.package = pkgs.pulseaudioFull;
    services.blueman.enable = true;
  };
}

{ config, lib, pkgs, ... }:
with lib;
let cfg = config.hardware.sane;
in
{
  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint ];
    };
    services.saned.enable = true;
    environment.systemPackages = with pkgs; [ simple-scan ];
  };
}

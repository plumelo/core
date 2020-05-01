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

    environment.systemPackages = with pkgs; [
      gnome3.simple-scan
    ];
    users.defaultUser.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}

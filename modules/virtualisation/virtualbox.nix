{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.virtualisation.virtualbox.host;
in {
  config = mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enableExtensionPack = true;
    };
  };
}

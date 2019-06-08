{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.virtualbox.host;
in {
  config = mkIf cfg.host.enable {
    virtualisation.virtualbox.host = {
      enableExtensionPack = true;
    };
  };
}

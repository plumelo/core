{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.virtualisation.lxd;
in {
  config = mkIf (cfg.enable && (config.networking.networkmanager.dns == "dnsmasq")) ({
    environment.etc."NetworkManager/dnsmasq.d/10-dns-lxd.conf".text = ''
      server=/lxd/10.0.4.1
      '';
    });
}

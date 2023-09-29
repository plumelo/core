{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.networking.nftables-pre;
  nftCfg = config.networking.nftables;
in
{
  options = {
    networking.nftables-pre = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      deps = mkOption {
        default = [ ];
        type = types.listOf types.str;
      };
      trustedInterfaces = mkOption {
        default = config.networking.firewall.trustedInterfaces;
        type = types.listOf types.str;
      };
    };
  };
  config = mkIf cfg.enable {
    networking.nftables = {
      enable = lib.mkDefault true;
      checkRuleset = lib.mkDefault false;
    };
    systemd.services.nftables = {
      before = lib.mkForce [ ];
      after = lib.mkForce ([ "network-online.target" ] ++ cfg.deps);
      wants = lib.mkForce cfg.deps;
    };

    systemd.services.nftables-pre =
      let
        ifs = concatStringsSep ", " (
          map (x: ''"${x}"'') cfg.trustedInterfaces
        );
      in
      {
        description = "nftables firewall pre";
        before = [ "network-pre.target" ];
        wantedBy = [ "network-pre.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeScript "nftables-rules" ''
            #! ${pkgs.nftables}/bin/nft -f
            flush ruleset
            table inet filter {
              chain input {
                type filter hook input priority filter; policy drop;
                ${optionalString (ifs != "") ''iifname { ${ifs} } accept comment "trusted interfaces"''}
              }
              chain forward {
                type filter hook forward priority filter; policy drop;
              }
            }
          '';
        };
      };
  };

}

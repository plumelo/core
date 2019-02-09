{ config, options, lib, pkgs, ... }:
with lib;
let cfg = config.virtualisation.lxc;
in
{
  options = {
    virtualisation.lxc.net = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };

      domain = mkOption {
        type = types.str;
        default = "local";
      };

      address = mkOption {
        type = types.str;
        default = "10.0.3.1";
      };

    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      virtualisation.lxc = {
        defaultConfig = ''
          lxc.apparmor.profile = unconfined
        '';
      };
    }

    (mkIf cfg.net.enable (mkMerge [
      {
        environment.etc."default/lxc" = {
          text = ''
            [ ! -f /etc/default/lxc-net ] || . /etc/default/lxc-net
          '';
        };

        environment.etc."default/lxc-net" = {
          text = ''
            LXC_DOMAIN="${cfg.net.domain}"
            LXC_ADDR="${cfg.net.address}"
            USE_LXC_BRIDGE="true"
          '';
        };

        virtualisation.lxc = {
          defaultConfig = ''
            lxc.net.0.type = veth
            lxc.net.0.link = lxcbr0
            lxc.net.0.flags = up
          '';
        };

        systemd.services = {
          lxc-net = {
            after = [ "network.target" "systemd-resolved.service" ];
            wantedBy = [ "multi-user.target" ];
            path = with pkgs; [ dnsmasq lxc iproute iptables glibc ];

            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = "yes";
              ExecStart = "${pkgs.lxc}/libexec/lxc/lxc-net start";
              ExecStop = "${pkgs.lxc}/libexec/lxc/lxc-net stop";
            };
          };
        };
      }
      (mkIf (config.networking.networkmanager.dns == "dnsmasq") {
        environment.etc."NetworkManager/dnsmasq.d/10-dns-lxc.conf".text = ''
          server=/${cfg.net.domain}/${cfg.net.address}
        '';
      })
    ]))
  ]);
}

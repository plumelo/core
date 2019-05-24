{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.virtualisation.lxc;
in {
  options = {
    virtualisation.lxc.net = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };

      domain = mkOption {
        type = types.string;
        default = "local";
      };

      addr = mkOption {
        type = types.string;
        default = "10.0.3.1";

      };

    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      lxc-templates
    ];

    system.activationScripts = {
      lxc = {
        text = ''
          mkdir -p /usr/share
          ln -sfn /run/current-system/sw/share/lxc /usr/share/lxc
        '';
        deps = [];
      };
    };

    virtualisation.lxc = {
      defaultConfig = ''
        lxc.apparmor.profile = unconfined
      '' + (if cfg.net.enable then ''
        lxc.net.0.type = veth
        lxc.net.0.link = lxcbr0
        lxc.net.0.flags = up
      '' else "");
    };

    environment.etc."default/lxc" = mkIf cfg.net.enable {
      text = ''
        [ ! -f /etc/default/lxc-net ] || . /etc/default/lxc-net
      '';
    };

    environment.etc."default/lxc-net".text = ''
      LXC_DOMAIN="${cfg.net.domain}"
      LXC_ADDR="${cfg.net.addr}"
    '' + (if cfg.net.enable then ''
      USE_LXC_BRIDGE="true"
    ''
    else "");

    systemd.services = mkIf cfg.net.enable {
      lxc-net = {
        after     = [ "network.target" "systemd-resolved.service" ];
        wantedBy  = [ "multi-user.target" ];
        path      = with pkgs; [ dnsmasq lxc iproute iptables glibc];

        serviceConfig = {
          Type            = "oneshot";
          RemainAfterExit = "yes";
          ExecStart       = "${pkgs.lxc}/libexec/lxc/lxc-net start";
          ExecStop        = "${pkgs.lxc}/libexec/lxc/lxc-net stop";
        };
      };
    };

    environment.pathsToLink = ["/share/lxc"];
  };
}

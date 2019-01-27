{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lxc-templates
  ];

  system.activationScripts = {
    lxc = {
      text = ''
        mkdir -p /usr/share
        ln -sfn /run/current-system/sw/share/lxc  /usr/share/lxc
      '';
      deps = [];
    }; 
  };

  virtualisation = {
    lxc = {
      enable = true;
      defaultConfig = ''
        lxc.apparmor.profile = unconfined
        lxc.net.0.type = veth
        lxc.net.0.link = lxcbr0
        lxc.net.0.flags = up
      '';
      lxcfs.enable = true;
    };
  };

  environment.etc."default/lxc".text = ''
    [ ! -f /etc/default/lxc-net ] || . /etc/default/lxc-net
  '';

  environment.etc."default/lxc-net".text = ''
    USE_LXC_BRIDGE="true"
    LXC_DOMAIN="local"
    LXC_ADDR="10.0.3.1"
  '';

  systemd.services.lxc-net = {
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

  environment.pathsToLink = ["/share/lxc"];
}


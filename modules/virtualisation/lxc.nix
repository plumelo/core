{ config, lib, pkgs, ... }:
{
  services.dnsmasq = {
    enable = true;
    extraConfig =
    if config.services.dnsmasq.enable then
      ''
      bind-interfaces
      except-interface=lxcbr0
      except-interface=lxdbr0
      listen-address=127.0.0.1
      server=/local/10.0.3.1
      server=/lxd/10.0.4.1
      ''
    else
      "";
  };
  networking.networkmanager.insertNameservers = ["127.0.0.1"];

  virtualisation = {
    lxc = {
      enable = true;
      defaultConfig = ''
        lxc.apparmor.profile = unconfined
        lxc.net.0.type = veth
        lxc.net.0.link = lxcbr0
        lxc.net.0.flags = up
      '';
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
    path      = [ pkgs.dnsmasq pkgs.lxc pkgs.iproute pkgs.iptables pkgs.glibc];

    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = "yes";
      ExecStart       = "${pkgs.lxc}/libexec/lxc/lxc-net start";
      ExecStop        = "${pkgs.lxc}/libexec/lxc/lxc-net stop";
    };
  };
}


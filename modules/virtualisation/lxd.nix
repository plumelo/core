{ config, lib, pkgs, ... }:
{
  # This doesn't seem to work
  security.apparmor = {
    enable = true;
    profiles = [
      "${pkgs.lxc}/etc/apparmor.d/usr.bin.lxc-start"
      "${pkgs.lxc}/etc/apparmor.d/lxc-containers"
    ];
    packages = [ pkgs.lxc ];
  };

  virtualisation.lxd.enable = true;
  #systemd.services.lxd.path = with pkgs; [ gzip dnsmas
  # lxc profile set default raw.lxc lxc.aa_allow_incomplete=1
  # sudo lxc network set lxdbr0 ipv4.address 10.0.4.1/24
  # And add your user to lxd group
}

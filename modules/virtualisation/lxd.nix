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
}

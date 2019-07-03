{ config, lib, pkgs, ... }: {
  fileSystems."/".options = [ "noatime" "nodiratime" ];

  boot.kernel.sysctl = { "vm.swappiness" = 10; };

  services.fstrim.enable = true;
}

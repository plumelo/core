{ config, options, lib, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    configDir="/var/lib/syncthing/.config";
  };
}

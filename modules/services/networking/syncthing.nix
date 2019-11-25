{ config, options, lib, pkgs, ... }:
{
  services.syncthing = {
    openDefaultPorts = true;
    configDir="/var/lib/syncthing/.config";
  };
}

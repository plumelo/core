{ config, options, lib, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    group = "syncthing";
  };
}

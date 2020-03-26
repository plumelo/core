{ config, options, lib, pkgs, ... }:
{
  services.syncthing = {
    openDefaultPorts = true;
  };
}

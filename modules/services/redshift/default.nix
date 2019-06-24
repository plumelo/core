{ config, lib, pkgs, ... }:
{
  services.redshift = {
    package   = pkgs.redshift-wayland;
    provider  = "geoclue2";
  };
}

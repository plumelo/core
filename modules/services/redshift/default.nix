{ config, lib, pkgs, ... }: {
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wayland;
    latitude = "47.15";
    longitude = "27.59";
  };
}

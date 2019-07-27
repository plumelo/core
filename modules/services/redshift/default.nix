{ config, lib, ... }:
let
  pkgs = import (builtins.fetchTarball {
    url = "https://github.com/matthias-t/nixpkgs/archive/master.tar.gz";
    sha256 = "07wprqw6pxn4zggnj22r1qd3wsqr5clprb891gh9wxc839z6v13g";
  }) { };
in {
  services.redshift = {
    enable = true;
    package = pkgs.redshift-wlroots;
    latitude = "47.15";
    longitude = "27.59";
  };
}

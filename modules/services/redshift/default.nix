{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
      (builtins.fetchTarball {
        url =
          "https://github.com/colemickens/nixpkgs-wayland/archive/afc347f.tar.gz";
        sha256 = "0kpzh9qdd3xgvnqzyivm3wjxmnz6m4mx6ay0npwngg81inkw7s4j";
      })
    }/pkgs/redshift-wayland" {
      inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
      geoclue = pkgs.geoclue2;
    };
in {
  services.redshift = {
    enable = true;
    package = redshift;
  };
  location = {
    latitude = 47.15;
    longitude = 27.59;
  };
}

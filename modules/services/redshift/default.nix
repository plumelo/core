{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
      (builtins.fetchTarball {
        url =
          "https://github.com/colemickens/nixpkgs-wayland/archive/97bd6f44fa7fc76750a12aceb1b3fdcc8bdfb8eb.tar.gz";
        sha256 = "119xm5cpz2q6vydj589pa3xz2jw2gzagiw47cs7bamq15fiyzlvx";
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

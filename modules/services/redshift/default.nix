{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
      (builtins.fetchTarball {
        url =
          "https://github.com/colemickens/nixpkgs-wayland/archive/26fdb0d.tar.gz";
        sha256 = "0acccs7d34vkpz5gd9rby45m62zx7inv4j0b44afql4dlcs3k8zl";
      })
    }/pkgs/redshift-wayland" {
      inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
      geoclue = pkgs.geoclue2;
    };
in {
  services.redshift = {
    package = redshift;
  };
  location = {
    latitude = 47.15;
    longitude = 27.59;
  };
}

{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
      (builtins.fetchTarball {
        url =
          "https://github.com/colemickens/nixpkgs-wayland/archive/95af0091603f2665893c871cef16714586517bfd.tar.gz";
        sha256 = "0dgadcrmjg21n4zd6cssbqdf62yaz7zpgpbn5sgpf7d5wzsh9871";
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

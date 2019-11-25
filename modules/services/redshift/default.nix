{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
      (builtins.fetchTarball {
        url =
          "https://github.com/colemickens/nixpkgs-wayland/archive/a2da560.tar.gz";
        sha256 = "0mh13a1wxjzgpcgiq8sbikmfwp0ffg09pg2nfig7qbb9a0wqjpwy";
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

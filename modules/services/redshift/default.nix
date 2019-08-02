{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
    (builtins.fetchTarball {
      url =
      "https://github.com/colemickens/nixpkgs-wayland/archive/13f640a0ad5c8072e9c21a7011962586398a8354.tar.gz";
      sha256 = "0rfsrfsh23xxj6srbpqpy6izawszk8s292m4kki9i9rb6jnd6r60";
    })
  }/pkgs/redshift-wayland" {
    inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = pkgs.geoclue2;
  };
in {
  services.redshift = {
    enable = true;
    package = redshift;
    latitude = "47.15";
    longitude = "27.59";
  };
}

{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
      (builtins.fetchTarball {
        url =
          "https://github.com/colemickens/nixpkgs-wayland/archive/10c0a8f64cd56253cc2ec55de4c1c5f2dedcbb10.tar.gz";
        sha256 = "15nnnk5k232v8gr2nhna722n1xdb5a44w2nh6bvj5dmcgy0imp85";
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

{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
      (builtins.fetchTarball {
        url =
          "https://github.com/colemickens/nixpkgs-wayland/archive/a659348f23edf9c94c4ffd207fbd0f20b6b89a26.tar.gz";
        sha256 = "12vwc94q6am9wy2z6nb351hdk9dxqmj1f955qd4a60hrc8mnidy8";
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

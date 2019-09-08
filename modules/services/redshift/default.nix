{ config, lib, pkgs, ... }:
let
  redshift = pkgs.callPackage "${
      (builtins.fetchTarball {
        url =
          "https://github.com/colemickens/nixpkgs-wayland/archive/7f80e3720a0f42d445eccd2ebbce9235d56933f9.tar.gz";
        sha256 = "0fllh3adw53yvs0x8mhff0skq4yd6dykj40yq9drvgr3qfwfj3bp";
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

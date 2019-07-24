self: super:
let
  waylandPkgs = ((import (builtins.fetchTarball {
    url =
    "https://github.com/colemickens/nixpkgs-wayland/archive/937a0dfc97cbc0db62f71a3d21490f58045ca82c.tar.gz";
    sha256 = "17a0h00q09xwzhsdna7166g4414p6kql6i48zph6aznhkxmk429a";
  })) self super).waylandPkgs;
in {
  waybar = super.waybar.override { pulseSupport = true; };
  wl-clipboard = (with super;
  wl-clipboard.overrideAttrs (old: rec {
    src = fetchFromGitHub {
      owner = "bugaevc";
      repo = "wl-clipboard";
      rev = "c010972e6b0d2eb3002c49a6a1b5620ff5f7c910";
      sha256 = "020l3jy9gsj6gablwdfzp1wfa8yblay3axdjc56i9q8pbhz7g12j";
    };
  }));
  redshift-wayland = waylandPkgs.redshift-wayland;
}

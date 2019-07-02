self: super:
let
  waylandPkgs = ((import (builtins.fetchTarball {
    url =
    "https://github.com/colemickens/nixpkgs-wayland/archive/f890e9c1bef82593aa0b2934e7848ac94df9adce.tar.gz";
    sha256 = "158xfvnigd3hjlc5mq3b71ysynrn9dj2c3qzllh0v556kr3w08ly";
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

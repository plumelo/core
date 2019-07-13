self: super:
let
  waylandPkgs = ((import (builtins.fetchTarball {
    url =
    "https://github.com/colemickens/nixpkgs-wayland/archive/a6ba3f1233233bd3bced584d33ae3fc4b961eb3b.tar.gz";
    sha256 = "0c64y2qhcwd3afxm9sy3pj9m7c5kj9ff0vv11paz7xwx67xig8lk";
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

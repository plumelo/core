self: super:
let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandPkgs = ((import (builtins.fetchTarball url)) self super).waylandPkgs;
in {

  waybar = super.waybar.override {
    pulseSupport = true;
  };
  wl-clipboard = (with super; wl-clipboard.overrideAttrs (old: rec {
    src = fetchFromGitHub {
      owner = "bugaevc";
      repo = "wl-clipboard";
      rev = "c010972e6b0d2eb3002c49a6a1b5620ff5f7c910";
      sha256 = "020l3jy9gsj6gablwdfzp1wfa8yblay3axdjc56i9q8pbhz7g12j";
    };

  }));
  redshift-wayland = waylandPkgs.redshift-wayland;
}

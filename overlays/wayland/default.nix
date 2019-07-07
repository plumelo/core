self: super:
let
  waylandPkgs = ((import (builtins.fetchTarball {
    url =
    "https://github.com/colemickens/nixpkgs-wayland/archive/75c2b4872a3208069c6a3bfba044dc16cad66440.tar.gz";
    sha256 = "06lbq02s6gbgicywih5jnfp30ljk58w7b7k710k47xm0gfc4kv0k";
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

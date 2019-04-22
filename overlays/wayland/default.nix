self: super:
let
  url = "https://github.com/colemickens/nixpkgs-wayland/archive/master.tar.gz";
  waylandPkgs = ((import (builtins.fetchTarball url)) self super).waylandPkgs;
in
{
  inherit (waylandPkgs) waybar redshift-wayland;
}

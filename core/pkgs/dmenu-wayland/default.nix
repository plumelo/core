{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, wayland-protocols, wayland, pango, cairo, libxkbcommon, glib, gob2, }:

stdenv.mkDerivation rec {
  pname = "dmenu-wayland";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "nyyManni";
    repo = pname;
    rev = "v${version}";
    sha256 = "1w32fx3hlz9r1h8b7vaf2jgj4kcghmr3gxcm9hxw7rac6gacavb1";
  };

  nativeBuildInputs = [ meson ninja pkgconfig wayland-protocols ];
  buildInputs = [ pango cairo libxkbcommon glib gob2 wayland ];

  meta = with stdenv.lib; {
    description = "dmenu-wl is an efficient dynamic menu for wayland (wlroots).";
    homepage = https://github.com/nyyManni/dmenu-wayland;
    platforms = platforms.linux;
  };
}

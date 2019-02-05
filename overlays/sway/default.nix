self: super:
with super;

let
  mkDerivation = stdenv.mkDerivation;
  wlroots =  mkDerivation rec {
    name = "wlroots";
    version = "0.3";
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "wlroots";
      rev = "721a810f72aed867176f3721a4462fc24c790954";
      sha256 = "01jya7f28iq8aivhgmmlkcl9jvwpaj1jih7ii50f83mk4v7wvh7x";
    };

    nativeBuildInputs = [ meson ninja pkgconfig ];

    mesonFlags = [
      "-Dauto_features=enabled"
    ];

    buildInputs = [
      wayland
      wayland-protocols
      libGL
      mesa_noglu
      libinput
      libxkbcommon
      pixman
      libcap
      udev
      xwayland
      ffmpeg-full
      git
      ctags
    ] ++ (with xorg; [
      xcbutilwm
      xcbutilimage
      xcbutilerrors
      libX11
    ]);
  };
in
{
  mako = mkDerivation rec {
    name = "mako-${version}";
    version = "1.2";
    src = fetchFromGitHub {
      owner = "emersion";
      repo = "mako";
      rev = "b30c786bdf8b90807e45ec0f52b292ee147ae1ff";
      sha256 = "1dw75cdvn34kmwdgzm228zvm0apd10rw1hx1k9xbmhihzf7jg76y";
    };

    nativeBuildInputs = [ meson ninja pkgconfig ];

    buildInputs = [
      wayland
      wayland-protocols
      mesa_noglu
      libinput
      libxkbcommon
      pango
      cairo
    ] ++ (with xorg; [
      xcbutilimage
    ]);
  };

  grim = mkDerivation rec {
    name = "grim-${version}";
    version = "1.0";

    src = fetchFromGitHub {
      owner = "emersion";
      repo = "grim";
      rev = "1e8dde32b6e5fd6b03230aea290840f64be515db";
      sha256 = "1bcvkggqszcwy6hg8g4mch3yr25ic0baafbd90af5s5mrhrjxxxz";
    };
    nativeBuildInputs = [ meson ninja pkgconfig ];
    buildInputs = [
      wayland
      wayland-protocols
      cairo
      libjpeg
    ];
  };

  slurp = mkDerivation rec {
    name = "slurp-${version}";
    version = "1.0";

    src = fetchFromGitHub {
      owner = "emersion";
      repo = "slurp";
      rev = "d9f3d741dc3de8c24198f41befc297e43054a523";
      sha256 = "05ivdf37f8cd02yh94f0kz3lpfn0w9qfn095isd941gwmq2v6r50";
    };
    nativeBuildInputs = [ meson ninja pkgconfig ];
    buildInputs = [
      wayland
      wayland-protocols
      cairo
    ];
  };
  swaylock = mkDerivation rec {
    name = "swaylock-${version}";
    version = "1.3";

    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "swaylock";
      rev = "effdea523158c8e30f7654a87402df155a2229ad";
      sha256 = "093nv1y9wyg48rfxhd36qdljjry57v1vkzrlc38mkf6zvsq8j7wb";
    };

    mesonFlags = [
      "-Dpam=enabled"
      "-Dgdk-pixbuf=enabled"
      ];
    nativeBuildInputs = [ meson ninja pkgconfig cmake ];

    buildInputs = [
      wayland
      wayland-protocols
      libxkbcommon
      cairo
      pango
      gdk_pixbuf
      pam
      git
      scdoc
    ];
  };
  sway = mkDerivation rec {
    name = "sway-${version}";
    version = "1.0-rc1";

    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "a1a99421a1150609bc8a54a2dd51dc9ec780d326";
      sha256 = "1xg2q3k1flgqpr2cy8xxm2x1jk7ykdlq0fx01jkw4am0kxaj8ivy";
    };
    nativeBuildInputs = [ meson ninja pkgconfig cmake ];

    mesonFlags = [
      "-Dauto_features=enabled"
    ];

    buildInputs = [
      pcre
      json_c
      wlroots
      wayland
      wayland-protocols
      libxkbcommon
      libevdev
      cairo
      pango
      libcap
      libinput
      gdk_pixbuf
      pam
      git
      scdoc
      xwayland
    ];
  };
}

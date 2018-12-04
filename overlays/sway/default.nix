self: super:
with super;

let
  mkDerivation = stdenv.mkDerivation;
  wlroots =  mkDerivation rec {
    name = "wlroots";
    version = "0.2";
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "wlroots";
      rev = version;
      sha256 = "0gfxawjlb736xl90zfv3n6zzf5n1cacgzflqi1zq1wn7wd3j6ppv";
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
      rev = "a0e798a582bd7bcaacca249778f11124e6610ae9";
      sha256 = "1zviksplk82yqhmdc72x39zd7m9b8rq80lc2gjypxixxf1niwxbd";
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
      rev = "d27b96f29e721f3b8b9666f5007d5cba6d0f2852";
      sha256 = "0akfjl54r0wgk9b0fks8x6h5hrisd6xvs4xvnbd9ry2zpkny22iy";
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
      rev = "95d8ec7e6b706961ffba3705033a9f57636aa65c";
      sha256 = "03igv8r8n772xb0y7whhs1pa298l3d94jbnknaxpwp2n4fi04syb";
    };
    nativeBuildInputs = [ meson ninja pkgconfig ];
    buildInputs = [
      wayland
      wayland-protocols
      cairo
    ];
  };

  sway = mkDerivation rec {
    name = "sway-${version}";
    version = "1.0-beta.2";

    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = version;
      sha256 = "0f9rniwizbc3vzxdy6rc47749p6gczfbgfdy4r458134rbl551hw";
    };
    nativeBuildInputs = [ meson ninja pkgconfig ];
    buildInputs = [
      pcre
      json_c
      wlroots
      wayland
      wayland-protocols
      libxkbcommon
      cairo
      pango
      libcap
      libinput
      gdk_pixbuf
      pam
      git
      scdoc
      xwayland
      git
    ];
  };
}

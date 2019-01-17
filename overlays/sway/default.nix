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
      rev = "10b1de6e718f1765f81131447d4b6b86bc78a6f4";
      sha256 = "19dly2qmaxsdmbqzhxxnpw9pimhrabw79jh534z0xys161b6rqsb";
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
      rev = "70637b40fe98bda420e279e2e059fc93a9f538d6";
      sha256 = "0mlkx3w72xhlh0df569rwbjv56h3yhykibbxcrh5my13chx9lrvg";
    };
    nativeBuildInputs = [ meson ninja pkgconfig cmake ];

    mesonFlags = [
      "-Denable-tray=true"
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
      git
    ];
  };
}

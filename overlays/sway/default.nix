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
      rev = "4f66565606c8958684c00f28d0b4996904c041bc";
      sha256 = "1vs43h3br5mw24flvsrfm7calyisxrj4iyawll8a9k69rh51k4nw";
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
      rev = "e3a69aa4017d6cb64a270fcc2e708c98cd9d2b39";
      sha256 = "1cd1jbpipcr4x2m5ci5q45w3c6gxxgwwv6zih3wjxw0j36ff1mz6";
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
      rev = "6994df611f55a4089209fdd5ad8d9301e4fb0167";
      sha256 = "1r7ryrv9w3g26p0zik7xg5db0bs6ibx12mjg1xs03wjld3cfcyal";
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
      rev = "a780cfa3cfc9616a258e9592b4111cf83dddeb93";
      sha256 = "1jrdbwalixiyqpg3zq0fqja77pqhx741f989d2dd2c5sdx6kfa4r";
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
      rev = "6b3be42264b9eaa8524ea4f0d93fbd1d82495d90";
      sha256 = "0al63s2690y2k9ymd7l13p2r28wpy6svziwcgjpasmyga9vckgxv";
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
    version = "1.0-rc3";

    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = "9350a52c0e8b502f9dc7f876da0527607a44bfec";
      sha256 = "0zczbiq7mprwsa6axaah1qas5jv5jvy054629vbsh49h4m12v04w";
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

self: super:
with super;

let
  mkDerivation = stdenv.mkDerivation;
  meson_4_8 =  meson.overridePythonAttrs(old: rec{
    src = python3Packages.fetchPypi {
      version = "0.48.0";
      pname = "meson"; 
      sha256 = "0qawsm6px1vca3babnqwn0hmkzsxy4w0gi345apd2qk3v0cv7ipc";
    };
    patches = with builtins; [
      (head old.patches)
      (elemAt old.patches 2)
    ];
    postFixup = ''
      ${old.postFixup}

      # Do not propagate Python
      rm $out/nix-support/propagated-build-inputs
    '';
  });
  wlroots =  mkDerivation rec {
    name = "wlroots";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "wlroots";
      rev = version;
      sha256 = "0xfipgg2qh2xcf3a1pzx8pyh1aqpb9rijdyi0as4s6fhgy4w269c";
    };

    nativeBuildInputs = [ meson_4_8 ninja pkgconfig ];

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
    version = "1.1";
    src = fetchFromGitHub {
      owner = "emersion";
      repo = "mako";
      rev = "bb1f3b2378d99fcf649cfaa2b8f5a7badc5f87d5";
      sha256 = "06nd5nhb2czj19l2hfpzys8l4m3r1jqb1v4b6xhjb7pski5zqm8g";
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
      rev = "97202f22003200edcc3fb5966ddc9b19cfe1c6f9";
      sha256 = "1cq8v4wiqjzg0p84f7l04ydbpirbplfm8zwmg2j2f28qcl5igylp";
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
      rev = "d907d308eb1eebf9b1be4a047edbc8f163bdd4b7";
      sha256 = "07aa3pwqm2a1cf60sipnzrdk1d7m0193jz22s15wqzxh93v3013l";
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
    version = "1.0-beta.1";

    src = fetchFromGitHub {
      owner = "swaywm";
      repo = "sway";
      rev = version;
      sha256 = "0h9kgrg9mh2acks63z72bw3lwff32pf2nb4i7i5xhd9i6l4gfnqa";
    };
    nativeBuildInputs = [ meson_4_8 ninja pkgconfig ];
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

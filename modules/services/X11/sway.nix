{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    mako = with super; stdenv.mkDerivation rec {
      name = "mako-${version}";
      version = "1.1";
      src = fetchFromGitHub {
        owner = "emersion";
        repo = "mako";
        rev = "3337d92894327325b40cf16b39e00b51e1c0b498";
        sha256 = "1xgc59xays6fp1b6hf3kq4hc9ypv0xyw0z1hbq6rgr5bvr31f5vg";
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

    grim = with super; stdenv.mkDerivation rec {
      name = "grim-${version}";
      version = "1.0";

      src = fetchFromGitHub {
        owner = "emersion";
        repo = "grim";
        rev = "f9d796bbc5e0afba83ee7c675a2c82949cbbc2d9";
        sha256 = "1cj3rjk965dwfa1ylkh663g9ywbrxgsljy8fs0hrlqybyr4qp1j7";
      };
      nativeBuildInputs = [ meson ninja pkgconfig ];
      buildInputs = [
        wayland
        wayland-protocols
        cairo
        libjpeg
      ];
    };

    slurp = with super; stdenv.mkDerivation rec {
      name = "slurp-${version}";
      version = "1.0";

      src = fetchFromGitHub {
        owner = "emersion";
        repo = "slurp";
        rev = "1fb12765544d8e8b7f431d91be0d911a6766b40a";
        sha256 = "12lhmvbdzvmdivaxvd56xcknfb1czgawa40pr8mdj3nmfwvyjl20";
      };
      nativeBuildInputs = [ meson ninja pkgconfig ];
      buildInputs = [
        wayland
        wayland-protocols
        cairo
      ];
    };

    meson_4_7 = with super; meson.overridePythonAttrs(old: rec{
      src = python3Packages.fetchPypi {
        version = "0.47.2";
        pname = "meson"; 
        sha256 = "06v795yhpdkhq61ag4h5ygwsgxar8iyhia0cj09y1dwyj5l5rpy4";
      };
    postFixup = ''
      ${old.postFixup}

      # Do not propagate Python
      rm $out/nix-support/propagated-build-inputs
    '';
    });

    wlroots_unstable = with super; stdenv.mkDerivation rec {
      name = "wlroots";
      version = "unstable";
      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "wlroots";
        rev = "0086dbed0983949af97d52feb67d417415a57aea";
        sha256 = "1c5rz1xdaghvqrg565xn11kjm9h8pmwpxgfsanv6gfvbr4qzl0wh";
      };

      nativeBuildInputs = [ self.meson_4_7 ninja pkgconfig ];

      mesonFlags = [
        "-Dauto_features=enabled"
        # "-Dxwayland=enabled"
        # "-Dxcb-errors=enabled"
        # "-Dxcb-icccm=enabled"
        # "-Dlibcap=enabled"
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

    sway = with super; stdenv.mkDerivation rec {
      name = "sway-${version}";
      version = "1.0-alpha.5";

      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "f7568e26e96abb55b5aaaad76133057f0d14b478";
        sha256 = "1r1hnnx26n5y1bhk8qm5f2xrljb0f5rb3bqkz81qha19clqwq65n";
      };
      nativeBuildInputs = [ meson ninja pkgconfig ];
      buildInputs = [
        pcre
        json_c
        self.wlroots_unstable
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
      ];
    };
  })];

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      i3status
      xwayland
      dmenu
      termite
      arc-theme
      arc-icon-theme
      paper-icon-theme
      brightnessctl
      mako
      grim
      slurp
      imagemagick
      android-udev-rules
      jmtpfs
    ];

    extraSessionCommands = ''
      export XKB_DEFAULT_LAYOUT=us
    '';
  };

  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    libinput = {
      enable = true;
    };
    desktopManager.xterm.enable = false;
    displayManager.slim.enable=true;
  };

  networking = {
    networkmanager.enable = true;
  };
  hardware = {
    opengl.enable = true;
  };

  services.udev.packages = with pkgs; [
    brightnessctl
    android-udev-rules
  ];
  programs.ssh.startAgent = true;
}

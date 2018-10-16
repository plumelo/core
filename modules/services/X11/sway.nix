{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    mako = with super; stdenv.mkDerivation rec {
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

    grim = with super; stdenv.mkDerivation rec {
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

    slurp = with super; stdenv.mkDerivation rec {
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

    meson_4_8 = with super; meson.overridePythonAttrs(old: rec{
      src = python3Packages.fetchPypi {
        version = "0.48.0";
        pname = "meson"; 
        sha256 = "0qawsm6px1vca3babnqwn0hmkzsxy4w0gi345apd2qk3v0cv7ipc";
      };
      patches =[
        (builtins.head old.patches)
        (builtins.elemAt old.patches 2)
      ];
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
        rev = "8beeb88309d87474e1b4e8eadcf245a24f04b2d0";
        sha256 = "0nnimd04mlqi44qcdn6fg2dhfsps5kzkdk5g1m5gzi05ciln6nd6";
      };

      nativeBuildInputs = [ self.meson_4_8 ninja pkgconfig ];

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

    sway = with super; stdenv.mkDerivation rec {
      name = "sway-${version}";
      version = "1.0-alpha.6";

      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "cd02d60a992ee38689a0d17fc69c4e2b1956f266";
        sha256 = "0fxbqg9b7k428krbhsvnbq8kmaxg4c07yin6n2r6aacx2v5wpa2k";
      };
      nativeBuildInputs = [ self.meson_4_8 ninja pkgconfig ];
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
    extraDisplaySettings = ''
      Option "TearFree" "true"
      Option "DRI" "3"
    '';
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

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

    wlroots_unstable = with super; stdenv.mkDerivation rec {
      name = "wlroots";
      version = "unstable";
      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "wlroots";
        rev = "24212df830e2848582121746fd0284bd2d7da67a";
        sha256 = "11xlqww5iqa5am2yf4j6pf9l3dpli3p29ci7ayak8agqy228s630";
      };

      nativeBuildInputs = [ meson ninja pkgconfig ];

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
      ] ++ (with xorg; [
        xcbutilwm
        xcbutilimage
        libX11
      ]);
    };

    sway = with super; stdenv.mkDerivation rec {
      name = "sway-${version}";
      version = "1.0-alpha.5";

      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "2c91afbb34f649fcd4de690be5bedba4d989a7f0";
        sha256 = "096cww48cdwcpw6w2vkxbgakxqcwlmlkcn77aqrl8k9028prd5zd";
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

{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    mako = with super; stdenv.mkDerivation rec {
      name = "mako-${version}";
      version = "1.0-unstable";
      src = fetchFromGitHub {
        owner = "emersion";
        repo = "mako";
        rev = "f496e7c1bd679ab972eebcb6a2fa02ab0a5e01ce";
        sha256 = "1yfm3bnq1wvi8gr1ayj4pdqh7h303npb43ix70dayb9k7ka764py";
      };

      nativeBuildInputs = [ meson ninja pkgconfig ];

      buildInputs = [
        wayland
        wayland-protocols
        # libGL
        #libdrm
        mesa_noglu
        libinput
        libxkbcommon
        # pixman
        # libcap
        # udev
        pango
        cairo
      ] ++ (with xorg; [
        # xcbutilwm
        xcbutilimage
        # libX11
      ]);
    };

    wlroots_unstable = with super; stdenv.mkDerivation rec {
      name = "wlroots";
      version = "unstable";
      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "wlroots";
        rev = "2a58d44";
        sha256 = "16h59jglnn1y4h0q71200i429pl1qv3b93ygr7zkvzpsgnm9vci0";
      };

      nativeBuildInputs = [ meson ninja pkgconfig ];

      buildInputs = [
        wayland
        wayland-protocols
        libGL
        #libdrm
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
      version = "1.0-alpha.3";

      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "bec982bba62db39f734d21ffbd2a3c8cefb3f6bd";
        sha256 = "0ki6f2b2z4fi8jibdaggjfzs4xaw3zllvc4k4la4rj55kbq7m64c";
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

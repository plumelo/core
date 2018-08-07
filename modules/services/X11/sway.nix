{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    mako = with super; stdenv.mkDerivation rec {
      name = "mako-${version}";
      version = "1.1";
      src = fetchFromGitHub {
        owner = "emersion";
        repo = "mako";
        rev = "v${version}";
        sha256 = "18krsyp9g6f689024dn1mq8dyj4yg8c3kcy5s88q1gm8py6c4493";
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

    wlroots_unstable = with super; stdenv.mkDerivation rec {
      name = "wlroots";
      version = "unstable";
      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "wlroots";
        rev = "28b0a40";
        sha256 = "07y7y11jaxaf55gdigz7r41868vgz3fdfrlngr4w29942lnbfl0v";
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
    
    grim = with super; stdenv.mkDerivation rec {
      name = "grim-${version}";
      version = "1.0";

      src = fetchFromGitHub {
        owner = "emersion";
        repo = "grim";
        rev = "1d6c877d7854916953b8b76ba3b79522b893d85b";
        sha256 = "0rrynfsp80f6l1b6lyx9gi40yh5m4pd7ygx97dgsbqwdwhqrn9yr";
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
        rev = "a94273e02a5b70ca92dc67a08486198552583818";
        sha256 = "0gj0y721a5mxir3lz5fpgpf5awqq49si23p4hiys7bpfp6yhqy6y";
      };
      nativeBuildInputs = [ meson ninja pkgconfig ];
      buildInputs = [
        wayland
        wayland-protocols
        cairo
      ];
    };


    sway = with super; stdenv.mkDerivation rec {
      name = "sway-${version}";
      version = "1.0-alpha.5";

      src = fetchFromGitHub {
        owner = "swaywm";
        repo = "sway";
        rev = "${version}";
        sha256 = "0v2fnvx9z1727cva46j4zrlph8wwvkgb1gqgy9hzizbwixf387sl";
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

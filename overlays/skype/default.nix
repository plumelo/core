self: super: 
let 
  rpath = with super; stdenv.lib.makeLibraryPath [
    alsaLib
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    glibc
    libsecret

    gnome2.GConf
    gdk_pixbuf
    gtk3

      atk
    at-spi2-atk

    gnome3.gnome-keyring

    libnotify
    libpulseaudio
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
    libv4l

    xorg.libxkbfile
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
    xorg.libxcb
  ];
in
{
  skypeforlinux = with super; skypeforlinux.overrideAttrs (old: rec { 
    version = "8.36.76.38";
    name = "skypeforlinux-${version}";
    src = fetchurl {
      url = "https://repo.skype.com/deb/pool/main/s/skypeforlinux/skypeforlinux_${version}_amd64.deb";
      sha256 = "15yyw9a2kdiq3zqwpggkrshysl54n3v4c7vbkfpdgh8c2s3xalav";
    };


nativeBuildInputs = [
    wrapGAppsHook
    glib # For setup hook populating GSETTINGS_SCHEMA_PATH
  ];

  postFixup = ''
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* -or -name \*.node\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/share/skypeforlinux $file || true
    done

    # Fix the desktop link
    substituteInPlace $out/share/applications/skypeforlinux.desktop \
      --replace /usr/bin/ $out/bin/ \
      --replace /usr/share/ $out/share/
  '';
  });
}

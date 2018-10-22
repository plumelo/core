self: super:
{
  avocode = with super; avocode.overrideAttrs (old: rec {
    name = "avocode-${version}";
    version = "3.5.6";

    src = fetchurl {
      url = "https://media.avocode.com/download/avocode-app/${version}/avocode-${version}-linux.zip";
      sha256 = "1zklpzwi1zl2cbrah90phzghrfaf6rwslrbivhvz2rhywyxdyfnr";
    };
    libPath = stdenv.lib.makeLibraryPath (with xorg; with gnome3; [
      stdenv.cc.cc.lib
      gdk_pixbuf
      glib
      gtk3
      atk
      at_spi2_atk
      pango
      cairo
      freetype
      fontconfig
      dbus
      nss
      nspr
      alsaLib
      cups
      expat
      udev
      libX11
      libxcb
      libXi
      libXcursor
      libXdamage
      libXrandr
      libXcomposite
      libXext
      libXfixes
      libXrender
      libXtst
      libXScrnSaver
    ]);
  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/avocode
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-rpath ${libPath}:$out/ $file
    done
  '';
  });
}

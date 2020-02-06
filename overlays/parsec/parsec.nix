{ pkgs ? import <nixpkgs> {} }:
with pkgs;
let
  desktopItem = makeDesktopItem {
    desktopName = "Parsec";
    exec = "parsecd";
    name = "parsec";
    type = "Application";
  };
  parsecd = stdenv.mkDerivation {
    name = "parsecd";
    src = fetchurl {
      url = "https://s3.amazonaws.com/parsec-build/package/parsec-linux.deb";
      sha256 = "0xbq87sz88ldisl65cpcpza2hqjr5y9npn2lmkznzb5qcjd99i5f";
    };
    nativeBuildInputs = [ dpkg ];
    unpackCmd = "dpkg -x $curSrc .";
    installPhase = ''
      mkdir $out
      mv * $out/
    '';
  };
in
buildFHSUserEnv {
  name = "parsecd";
  targetPkgs = pkgs:
    with pkgs; [
      parsecd
      alsaLib
      cups
      dbus
      fontconfig
      freetype
      libGL
      libpulseaudio
      libsamplerate
      libudev
      libva
      libxkbcommon
      nas
      stdenv.cc.cc.lib
      vulkan-loader
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcursor
      xorg.libXext
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXrender
      xorg.libXxf86vm
      xorg.libxcb
    ];
  runScript = "/usr/bin/parsecd";
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    ln -sfv ${parsecd}/share/icon $out/share/icons
    ln -sfv ${desktopItem} $out/share/applications
  '';
}

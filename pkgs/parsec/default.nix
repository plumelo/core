{ stdenv, makeDesktopItem, dpkg, fetchurl, buildFHSUserEnv }:
let
  desktopItem = makeDesktopItem {
    desktopName = "Parsec";
    exec = "parsecd";
    name = "parsec";
    icon = "parsecd";
    type = "Application";
  };
  parsecd = stdenv.mkDerivation {
    name = "parsecd";
    src = fetchurl {
      url = "https://builds.parsecgaming.com/package/parsec-linux.deb";
      hash = "sha256-DHIH9Bk3f8NeMESKzQDYcBMArFpEk2rG2HpGjJr8zcE=";
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
      alsa-lib
      cups
      dbus
      fontconfig
      freetype
      libGL
      libpulseaudio
      libsamplerate
      udev
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
      openssl
      ffmpeg
    ];
  runScript = "/usr/bin/parsecd";
  profile = ''
    export LIBVA_DRIVER_NAME=radeonsi
  '';
  extraInstallCommands = ''
    mkdir -p $out/share/{applications,pixmaps}
    ln -sfv ${parsecd}/share/icons/hicolor/256x256/apps/parsecd.png $out/share/pixmaps
    ln -sfv ${desktopItem} $out/share/applications
  '';
}

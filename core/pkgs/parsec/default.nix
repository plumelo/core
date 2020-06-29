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
      sha256 = "1hfdzjd8qiksv336m4s4ban004vhv00cv2j461gc6zrp37s0fwhc";
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
    mkdir -p $out/share/{applications,pixmaps}
    ln -sfv ${parsecd}/share/icons/hicolor/256x256/apps/parsecd.png $out/share/pixmaps
    ln -sfv ${desktopItem} $out/share/applications
  '';
}

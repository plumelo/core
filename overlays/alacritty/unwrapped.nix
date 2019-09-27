{ stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,

  cmake,
  gzip,
  makeWrapper,
  ncurses,
  pkgconfig,
  python3,

  expat,
  fontconfig,
  freetype,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libXxf86vm,
  libxcb,
  libxkbcommon,
  wayland,
  xdg_utils }:

with rustPlatform;

let
  rpathLibs = [
    expat
    fontconfig
    freetype
    libGL
    libX11
    libXcursor
    libXi
    libXrandr
    libXxf86vm
    libxcb
  ] ++ lib.optionals stdenv.isLinux [
    libxkbcommon
    wayland
  ];
in buildRustPackage rec {
  pname = "alacritty";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = pname;
    rev = "c1f089970fd3d4b9137d07647f8cd028b2b5b3a9";
    sha256 = "023lqrmdqf5pdpkpc4zqjpniv9mnl1xzxkw41gl40xl0a5vxm6cp";
  };

  cargoSha256 = "1wcx8zwhhryhaq3i0yshqz5b73dyjprmz816n8nd0lk8rmf6az0z";

  nativeBuildInputs = [
    cmake
    gzip
    makeWrapper
    ncurses
    pkgconfig
    python3
  ];

  buildInputs = rpathLibs;

  outputs = [ "out" "terminfo" ];
  postPatch = ''
    substituteInPlace alacritty_terminal/src/config/mouse.rs \
      --replace xdg-open ${xdg_utils}/bin/xdg-open
  '';

  postBuild = lib.optionalString stdenv.isDarwin "make app";

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty

  '' + (if stdenv.isDarwin then ''
    mkdir $out/Applications
    cp -r target/release/osx/Alacritty.app $out/Applications/Alacritty.app
  '' else ''
    install -D extra/linux/alacritty.desktop -t $out/share/applications/
    install -D extra/logo/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  '') + ''

    install -D extra/completions/_alacritty -t "$out/share/zsh/site-functions/"
    install -D extra/completions/alacritty.bash -t "$out/etc/bash_completion.d/"
    install -D extra/completions/alacritty.fish -t "$out/share/fish/vendor_completions.d/"

    install -dm 755 "$out/share/man/man1"
    gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"

    install -dm 755 "$terminfo/share/terminfo/a/"
    tic -x -o "$terminfo/share/terminfo" extra/alacritty.info
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    runHook postInstall
  '';

  dontPatchELF = true;
}

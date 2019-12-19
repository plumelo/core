self: super:
with super; {
  nerdfont_dejavu = stdenv.mkDerivation rec {
    name = "nerdfont-dejavu";

    src = fetchurl {
      url =
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/DejaVuSansMono.zip";
        sha256 = "06xk9qgw78xrbsq0kx9xxqff1fg4mxkyypi113mzvdjbx5khyfha";
    };

    unpackCmd = ''
      ${unzip}/bin/unzip $curSrc -d fonts
    '';
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp * $out/share/fonts/opentype
    '';
  };
}

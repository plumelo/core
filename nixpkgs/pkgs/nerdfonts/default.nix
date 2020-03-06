{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "nerdfonts-dejavu";

  src = fetchurl {
    url =
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DejaVuSansMono.zip";
    sha256 = "03qfrkzmhnn8dwgx4qhiigbz4dxs3957hydlr0j8vxl89j8c9g1z";
  };

  unpackCmd = ''
    ${unzip}/bin/unzip $curSrc -d fonts
  '';
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp * $out/share/fonts/opentype
  '';
}

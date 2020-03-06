{ stdenv, fetchFromGitHub, cmake, gcc, pciutils }:

stdenv.mkDerivation rec {
  name = "RyzenAdj";
  version = "0.5.3-unstable";

  src = fetchFromGitHub {
    rev = "82afad3";
    owner = "FlyGoat";
    repo = name;
    sha256 = "1rdmhx0vsyzv2xj2snjb9q51y2rcglwfswmx8lcah3jw8l0x5aa5";
  };
  nativeBuildInputs = [ cmake gcc ];
  buildInputs = [ pciutils ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -av ryzenadj $out/bin
    cp -av libryzenadj.so $out/lib
  '';
}

{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "nord-kakoune";
  version = "2019-08-03";
  src = fetchFromGitHub {
    owner = "rubberydub";
    repo = name;
    rev = "4db42f2c959c53afc37ecef1c2f31bdd5c1d1147";
    sha256 = "13axdr1cqzjy8nl6iphd8rpn3bxd7b1524znrz1rg82bccm80zbc";
  };

  installPhase = ''
    mkdir -p $out/share/kak/colors/nord-kakoune
    cp -r *.kak $out/share/kak/colors/nord-kakoune
  '';
}

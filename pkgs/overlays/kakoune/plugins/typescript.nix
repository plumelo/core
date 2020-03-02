{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "kakoune-typescript";
  version = "2018-06-05";
  src = fetchFromGitHub {
    owner = "atomrc";
    repo = name;
    rev = "ee5ec88e01fe0e44d2cd97a13a13b853140657b7";
    sha256 = "1a2hxrkrii6zqyl7aqnrnlcm32hl2h1d2xhis0px4j7lix1ssw2y";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r *.kak $out/share/kak/autoload/plugins/typescript
  '';
}

{ vimUtils, fetchFromGitHub, makeWrapper, callPackage }:
with vimUtils; {
  onehalfdark = buildVimPlugin {
    pname = "onehalfdark-vim";
    version = "0.0.1";
    src = ./onehalfdark.vim;

    unpackCmd = ''
      mkdir -p out/colors;
      ln -s $curSrc out/colors/onehalfdark.vim
    '';

    buildPhase = ":";
    configurePhase = ":";
  };
}

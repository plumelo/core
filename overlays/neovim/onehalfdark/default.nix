{ buildVimPlugin }:

buildVimPlugin {

  pname= "onehalf-vim";
  version = "0.0.1";
  src= ./onehalfdark.vim;

  unpackCmd = ''
      mkdir -p out/colors;
      ln -s $curSrc out/colors/onehalfdark.vim
      ls -al $curSrc
  '';

  buildPhase = ":";
  configurePhase =":";

}

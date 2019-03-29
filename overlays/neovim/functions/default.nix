{ buildVimPlugin }:

buildVimPlugin {

  pname= "functions";
  version = "0.0.1";
  src= ./opt.vim;

  unpackCmd = ''
    mkdir -p out/autoload;
    ln -s $curSrc out/autoload/opt.vim
    ls -al $curSrc
  '';

  buildPhase = ":";
  configurePhase =":";

}

{ buildVimPlugin }:

buildVimPlugin {

  pname= "mappings";
  version = "0.0.1";
  src= ./mappings.vim;

  unpackCmd = ''
    mkdir -p out/plugin;
    ln -s $curSrc out/plugin/mappings.vim
    ls -al $curSrc
  '';

  buildPhase = ":";
  configurePhase =":";

}

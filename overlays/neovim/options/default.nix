{ buildVimPlugin }:

buildVimPlugin {

  pname= "options";
  version = "0.0.1";
  src= ./options.vim;

  unpackCmd = ''
  mkdir -p out/plugin;
  ln -s $curSrc out/plugin/options.vim
  ls -al $curSrc
  '';

  buildPhase = ":";
  configurePhase =":";

}

{ buildVimPlugin }:

buildVimPlugin {

  pname= "configs";
  version = "0.0.1";
  src= ./configs.vim;

  unpackCmd = ''
    mkdir -p out/plugin;
    ln -s $curSrc out/plugin/configs.vim
    ls -al $curSrc
    '';

    buildPhase = ":";
    configurePhase =":";

}

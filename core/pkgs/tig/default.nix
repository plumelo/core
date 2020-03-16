{ symlinkJoin, gitAndTools, makeWrapper }:

symlinkJoin {
  name = "tig-with-config";
  paths = [ gitAndTools.tig ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/tig --set TIGRC_USER ${./tigrc}
  '';
}

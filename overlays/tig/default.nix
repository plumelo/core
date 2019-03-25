self: super:
with super;
{
  gitAndTools = gitAndTools // {
    tig = super.symlinkJoin {

    name = "tig-with-config";

    paths = [gitAndTools.tig];
    nativeBuildInputs = [ super.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/tig --set TIGRC_USER ${ ./tigrc}
    '';
    };
  };
}

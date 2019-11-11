self: super:
with super; {
  gitAndTools = gitAndTools // {
    tig = super.symlinkJoin {

      name = "tig-with-config";

      paths = [
        (gitAndTools.tig.overrideAttrs (old: rec {
          pname = "tig";
          version = "2.4.2";
          name = "${pname}-${version}";

          src = fetchFromGitHub {
            owner = "jonas";
            repo = pname;
            rev = "6642c11425a2d7432d968146025b6d9a96db5d64";
            sha256 = "0pm89f32cxmdqkd9r26z6fmsz41wpgkmgbk7aasq3pwj5gmrrpvc";
          };
        }))
      ];

      nativeBuildInputs = [ super.makeWrapper ];

      postBuild = ''
        wrapProgram $out/bin/tig --set TIGRC_USER ${./tigrc}
      '';
    };
  };
}

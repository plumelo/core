self: super:
with super;
{
  gitAndTools = gitAndTools // {
    tig = super.symlinkJoin {

      name = "tig-with-config";

      paths = [
        (gitAndTools.tig.overrideAttrs(old: rec {
          pname = "tig";
          version = "2.4.2";
          name = "${pname}-${version}";

          src = fetchFromGitHub {
            owner = "jonas";
            repo = pname;
            rev = "ea43f8be22c7b985c7c752d938579fe14d8e9f08";
            sha256 = "1x95rvg8m85cda5nl0nwlmkqkar0ahf4sw93km6mfgjhkk5igmrb";
          };
        }))
      ];

      nativeBuildInputs = [ super.makeWrapper ];

      postBuild = ''
        wrapProgram $out/bin/tig --set TIGRC_USER ${ ./tigrc}
      '';
    };
  };
}

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
            rev = "36ced9aff39fcbe13e08cc4b63ab2afc84f5bc6f";
            sha256 = "1dg0a37xr61d7myc5pci3ag8h54wdv3vwqwhlakxg1y137acfc28";
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

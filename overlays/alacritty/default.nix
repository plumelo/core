self: super:
let
  alacritty = (with super; super.callPackage ./unwrapped.nix {
    inherit (xorg) libXcursor libXxf86vm libXi;
  });
in {
  alacritty = super.symlinkJoin {
    name = "alacritty-with-config-${alacritty.version}";

    paths = [ alacritty ];
    nativeBuildInputs = [ super.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/alacritty \
        --add-flags "--config-file ${./config}" \
    '';

    passthru.terminfo = alacritty.terminfo;
  };

}

self: super:
let
  alacritty = super.alacritty;
in {
  alacritty = super.symlinkJoin {
    name = "alacritty-with-config-${alacritty.version}";

    paths = [ alacritty ];
    nativeBuildInputs = [ super.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/alacritty \
        --add-flags "--config-file ${./config}" \
        --set-default "WINIT_HIDPI_FACTOR" "1" \
    '';

    passthru.terminfo = alacritty.terminfo;
  };
}

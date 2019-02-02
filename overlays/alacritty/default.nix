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
        --set-default "LD_LIBRARY_PATH" "/run/opengl-driver/lib:/run/opengl-driver-32/lib"
    '';

    passthru.terminfo = alacritty.terminfo;
  };
}

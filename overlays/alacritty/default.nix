self: super:
let 
  alacritty = import ./unwrapped.nix self super;
in { 
  alacritty = super.symlinkJoin {
    name = "alacritty-with-config-${alacritty.version}";

    paths = [ alacritty ];
    nativeBuildInputs = [ super.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/alacritty \
        --add-flags "--config-file ${./config}" \
        --set-default "LD_LIBRARY_PATH" "/run/opengl-driver/lib:/run/opengl-driver-32/lib"
    '';

    passthru.terminfo = alacritty.terminfo;
  };
}

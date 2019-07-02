self: super:
with super; {
  alacritty = symlinkJoin {
    name = "alacritty-with-config-${alacritty.version}";

    paths = [ alacritty ];
    nativeBuildInputs = [ makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/alacritty \
        --add-flags "--config-file ${./config}" \
    '';

    passthru.terminfo = alacritty.terminfo;
  };

}

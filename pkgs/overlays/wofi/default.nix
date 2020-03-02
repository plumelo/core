self: super:
with super; {
  wofi = runCommand "wofi" { nativeBuildInputs = [ makeWrapper ]; } ''
     mkdir -p $out/bin

    makeWrapper ${
      wofi.overrideAttrs
      (old: { nativeBuildInputs = old.nativeBuildInputs ++ [ wrapGAppsHook ]; })
    }/bin/wofi $out/bin/wofi \
      --add-flags "-c ${
        writeText "config" ''
          width=700
          height=400
          mode=drun
          colors=colors
          filter_rate=100
        ''
      } -s ${
        writeText "style" ''
          window {
            margin: 10px;
            border:  10px;
            padding: 50px;
          }
          #text {
            margin: 5px;
          }
        ''
      }"
  '';
}

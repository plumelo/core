self: super:
let
  alacritty = (with super; super.callPackage ./unwrapped.nix {
    inherit (xorg) libXcursor libXxf86vm libXi;
    inherit (darwin) cf-private;
    inherit (darwin.apple_sdk.frameworks) AppKit CoreFoundation CoreGraphics CoreServices CoreText Foundation OpenGL;
  });
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

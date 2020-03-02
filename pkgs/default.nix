let
  pkgsPath = import ./release.nix;
  pkgs = import pkgsPath { overlays = []; };
  patches = pkgs.callPackage ./patches.nix {};
in
pkgs.runCommandNoCCLocal "nixpkgs" { inherit patches; } ''
  cp -r ${pkgsPath} $out
  chmod -R +w $out
  for p in $patches; do
    echo "Applying patch $p";
    patch -d $out -p1 < "$p";
  done
''

{ callPackage }: {
  typescript = callPackage ./typescript.nix { };
  nord = callPackage ./nord.nix { };
}

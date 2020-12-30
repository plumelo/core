{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/ea3638a3fb26";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.vision = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ ... }: {
          imports = [ ./modules ];
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ (import ./core/overlays/packages) ];
        })
      ];
    };
  };
}

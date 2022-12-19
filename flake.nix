{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = github:nix-community/NUR;
  };

  outputs = { self, nixpkgs, home-manager, nur }:
    let
      pathToAttrs = with builtins; path: listToAttrs (map
        (name: {
          name = nixpkgs.lib.removeSuffix ".nix" name;
          value = toString path + "/" + name;
        })
        (filter (n: match ".*\\.nix" n != null) (attrNames (readDir path)))
      );
    in
    {
      overlay = import ./pkgs;

      nixosModules = {
        core = { ... }: {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ self.overlay nur.overlay ];
          nix.registry.nixpkgs.flake = nixpkgs;
        };
        ssh = ./modules/programs/ssh;
        lxc = ./modules/virtualisation/lxc.nix;
        lxd = ./modules/virtualisation/lxd/default.nix;
        sane = ./modules/hardware/sane.nix;
        bluetooth = ./modules/hardware/bluetooth.nix;
        wine = ./modules/virtualisation/wine.nix;
        home = home-manager.nixosModules.home-manager;
        home-config.home-manager = { useGlobalPkgs = true; useUserPackages = true; };
      };
      nixosModule = self.nixosModules.core;
      homeModules = pathToAttrs ./homes;

      nur = nur;
      home-manager = home-manager;
    };
}

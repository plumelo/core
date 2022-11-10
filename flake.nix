{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let pathToAttrs = with builtins; path: listToAttrs (map
      (name: {
        name = nixpkgs.lib.removeSuffix ".nix" name;
        value = toString path + "/" + name;
      })
      (filter (n: match ".*\\.nix" n != null) (attrNames (readDir path)))
    ); in
    {
      overlay = import ./pkgs;

      nixosModules = {
        core = { ... }: {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ self.overlay ];
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
    };
}

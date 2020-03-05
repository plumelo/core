{ config, options, lib, pkgs, ... }: {
  nix = {
    buildCores = 0;
    nixPath = [
      "nixpkgs=${toString <nixpkgs>}"
      "nixpkgs-overlays=${toString <nixpkgs-overlays>}"
      "nixos-config=${toString <nixos-config>}"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "20.03";
}

{ config, options, lib, pkgs, ... }:
with builtins;
let
  overlaysPath = ../overlays;
  isDir = path: pathExists (path + "/.");
  overlays = path:
    if isDir path then
      let content = readDir path; in
        map
          (n: import (path + ("/" + n)))
          (filter
            (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix")))
            (attrNames content)
          )
    else
      import path;
in
{
  nix = {
    buildCores = 0;
    nixPath = 
      options.nix.nixPath.default ++
    ["nixpkgs-overlays=${toString overlaysPath}"];
  };

  nixpkgs.overlays = [
    (self: super:
      lib.foldl (p: n: p  // n self super) ({}) (overlays overlaysPath)
    )
  ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    acl
    wget
  ];
}

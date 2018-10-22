{ config, lib, pkgs, ... }:
let local = ./locals.nix;
in
{
  imports = (if builtins.pathExists local then [local] else []) ++
    [
      ./modules/base.nix
    ];
}

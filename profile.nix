{ config, lib, pkgs, ... }:
let local = ./local.nix;
in
{
  imports = (if builtins.pathExists local then [local] else []) ++
    [
      ./modules/base.nix
    ];
}

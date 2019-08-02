#!/bin/sh
nixpkgs=$(nix-instantiate --read-write-mode --eval ./release.nix | tr -d \")
NIX_CFLAGS_COMPILE="-O3 -march=native -mtune=native" nixos-rebuild -I nixos-config=configuration.nix -I nixpkgs=$nixpkgs -I nixpkgs-overlays=./overlays "$@"

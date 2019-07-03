#!/bin/sh
nixpkgs=$(nix-instantiate --read-write-mode --eval ./release.nix | tr -d \")
nixos-rebuild -I nixos-config=configuration.nix -I nixpkgs=$nixpkgs -I nixpkgs-overlays=./overlays "$@"

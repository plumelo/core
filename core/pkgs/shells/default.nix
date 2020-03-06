{ pkgs, callPackage }:

{
  react = callPackage ./react.nix { inherit (pkgs) yarn-completion; };
  polymer = callPackage ./polymer.nix { inherit (pkgs) yarn-completion; };
  ansible = callPackage ./ansible.nix { inherit (pkgs) ansible-completion; };
  vagrant = callPackage ./vagrant.nix {};
}

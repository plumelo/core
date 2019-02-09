self: super:
let
  inherit (super) callPackage;
in
{
  gnome-ssh-askpass3 = callPackage ./gnome-ssh-askpass3 { };
  box2lxd = callPackage ./box2lxd/default.nix { };
  ryzenadj = callPackage ./ryzenadj/default.nix { };
  parsec-client = callPackage ./parsec/default.nix { };
  kak = callPackage ./kakoune { };
}

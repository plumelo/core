self: super:
{
  parsec-client = import ./parsec.nix { pkgs = super;};
}

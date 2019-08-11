self: super:
with super; {
  shells = {
    react = super.callPackage ./react.nix { inherit (self) yarn-completion; };
    polymer =
      super.callPackage ./polymer.nix { inherit (self) yarn-completion; };
    ansible =
      super.callPackage ./ansible.nix { inherit (self) ansible-completion; };
    vagrant = super.callPackage ./vagrant.nix {};
  };
}

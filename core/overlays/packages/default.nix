self: super:
let
  callPackage = super.lib.callPackageWith super;
in
rec {
  alacritty = callPackage ../../pkgs/alacritty/default.nix {};
  gitAndTools = super.gitAndTools // { tig = callPackage ../../pkgs/tig/default.nix {}; };
  dmenu-wayland = callPackage ../../pkgs/dmenu-wayland/default.nix {};
  gnome-ssh-askpass3 = callPackage ../../pkgs/openssh/default.nix {};
  lxc-templates = callPackage ../../pkgs/lxc-templates/default.nix {};
  nerdfonts_dejavu = callPackage ../../pkgs/nerdfonts/default.nix {};
  box2lxd = callPackage ../../pkgs/box2lxd/default.nix {};
  ryzenadj = callPackage ../../pkgs/ryzenadj/default.nix {};
  parsec-client = callPackage ../../pkgs/parsec/default.nix {};
  shells = callPackage ../../pkgs/shells/default.nix {};
  yarn-completion = callPackage ../../pkgs/yarn-completion/default.nix {};
  neovim = callPackage ../../pkgs/neovim {};
  kak = callPackage ../../pkgs/kakoune {};
}

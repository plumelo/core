self: super:
let
  callPackage = super.lib.callPackageWith super;
in
{
  alacritty = callPackage ../../pkgs/alacritty/default.nix {};
  tig = callPackage ../../pkgs/tig/default.nix {};
  wofi = callPackage ../../pkgs/wofi/default.nix {};
  dmenu-wayland = callPackage ../../pkgs/dmenu-wayland/default.nix {};
  gnome-ssh-askpass3 = callPackage ../../pkgs/openssh/default.nix {};
  lxc-templates = callPackage ../../pkgs/lxd/default.nix {};
  nerdfonts_dejavu = callPackage ../../pkgs/fonts/default.nix {};
  box2lxd = callPackage ../../pkgs/box2lxd/default.nix {};
  ansible-completion = callPackage ../../pkgs/ansible-completion/default.nix {};
  ryzenadj = callPackage ../../pkgs/ryzenadj/default.nix {};
  parsec-client = callPackage ../../pkgs/parsec/default.nix {};
  shells = callPackage ../../pkgs/shells/default.nix {};
  yarn-completion = callPackage ../../pkgs/yarn-completion/default.nix {};
  neovim = callPackage ../../pkgs/neovim {};
  kak = callPackage ../../pkgs/kakoune {};
}

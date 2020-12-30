{ ... }: {
  imports = [
    ./users/default-user.nix
    ./hardware/bluetooth.nix
    ./hardware/sane.nix
    ./programs/bash
    ./programs/tmux.nix
    ./programs/git
    ./programs/ssh
    ./programs/lf
    ./virtualisation/lxc.nix
    ./virtualisation/lxd.nix
    ./virtualisation/virtualbox.nix
    ./virtualisation/wine.nix
    ./programs/sway
  ];
}

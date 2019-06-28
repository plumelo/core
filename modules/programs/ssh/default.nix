{ config, options, lib, pkgs, ... }:
let
  cfg = config.programs.ssh;
  askPassword = "${pkgs.gnome-ssh-askpass3}/bin/gnome-ssh-askpass3";
  askPasswordWrapper = pkgs.writeScript "kssh-askpass-wrapper" ''
    #! ${pkgs.runtimeShell} -e
    export DISPLAY=:0
    exec ${askPassword} 2>/tmp/ask.log
  '';
in {
  programs.ssh.startAgent = true;
  systemd.user.services.ssh-agent.environment.SSH_ASKPASS = lib.mkForce askPasswordWrapper;
  environment.variables.SSH_ASKPASS = lib.mkForce askPassword;
  programs.ssh.extraConfig = ''
    Host github.com
    ControlMaster auto
    ControlPath ~/.ssh/sockets-%r@%h-%p
    ControlPersist 600
  '';
}

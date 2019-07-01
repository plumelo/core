{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.ssh;
  askPassword = "${pkgs.gnome-ssh-askpass3}/bin/gnome-ssh-askpass3";
  askPasswordWrapper = pkgs.writeScript "kssh-askpass-wrapper" ''
    #! ${pkgs.runtimeShell} -e
    export DISPLAY=:0
    exec ${askPassword} 2>/tmp/ask.log
  '';
in {
  options = {
    programs.ssh = {
      persistentHosts = mkOption {
        type = types.listOf types.str;
        default = [ "github.com" "bitbucket.org" ];
      };
    };
  };

  config = {
    programs.ssh.startAgent = true;
    systemd.user.services.ssh-agent.environment.SSH_ASKPASS = mkForce askPasswordWrapper;
    environment.variables.SSH_ASKPASS = mkForce askPassword;
    programs.ssh.extraConfig = ''
      Host ${builtins.concatStringsSep " " cfg.persistentHosts}
        ControlMaster auto
        ControlPath ~/.ssh/sockets-%r@%h-%p
        ControlPersist 600
    '';
  };
}

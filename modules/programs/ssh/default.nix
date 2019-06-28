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
  domainToHostname = i: "Hostname " + i + "\n";
  phostsMap = map domainToHostname cfg.persistentHosts;
  hosts = lib.concatStrings phostsMap;
in {
  options = {
    programs.ssh = {
      persistentHosts = mkOption {
        type = types.listOf types.str;
        default = [];
      };
    };
  };

  config = {
    programs.ssh.startAgent = true;
    systemd.user.services.ssh-agent.environment.SSH_ASKPASS = mkForce askPasswordWrapper;
    environment.variables.SSH_ASKPASS = mkForce askPassword;
    programs.ssh.extraConfig = ''
      Host github.com
      ${hosts}
      ControlMaster auto
      ControlPath ~/.ssh/sockets-%r@%h-%p
      ControlPersist 600
    '';
  };
}

{ config, options, lib, pkgs, ... }:
with lib;
let cfg = config.users.defaultUser;

in {
  options.users.defaultUser = {
    name = mkOption {
      type = types.str;
      default = null;
    };
    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "The user's auxiliary groups.";
    };
  };

  config = mkIf (cfg.name != null) {
    users = {
      groups."${cfg.name}" = { gid = 1000; };
      users."${cfg.name}" = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [
          "${cfg.name}"
          "wheel"
          "disk"
          "audio"
          "video"
          "networkmanager"
          "systemd-journal"
        ] ++ cfg.extraGroups;
        initialPassword = "${cfg.name}";
        packages = mkDefault cfg.packages;
      };
    };
  };
}

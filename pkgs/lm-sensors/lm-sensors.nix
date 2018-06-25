{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    lm_sensors = with super; lm_sensors.overrideAttrs(old: rec {
      src = fetchFromGitHub {
        owner = "groeck";
        repo = "lm-sensors";
        rev = "70f7e0848410b9ca4dde7abff669bbbecbf137e0";
        sha256 = "18896dqjym1jb5vvrdhg2hxbd2q0pnwrxh4jczcax3s0b589z1kj";
      };
      patches = [ ./config.patch ];
      NIX_CFLAGS_COMPILE = toString (old.NIX_CFLAGS_COMPILE or "") + " -DDEFAULT_CONFIG_DIR=\"/etc/sensors.d\"";
    });
  })];
}

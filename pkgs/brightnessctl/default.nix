{ config, lib, pkgs, ... }:
{
  nixpkgs.overlays = [( self: super: {
    brightnessctl = with super; brightnessctl.overrideAttrs(old: rec {
      makeFlags = "PREFIX= DESTDIR=$(out) INSTALL_UDEV_RULES=1";
      patchPhase = ''
      substituteInPlace 90-brightnessctl.rules --replace /bin/ ${coreutils}/bin/
      '';
    });
  })];
}


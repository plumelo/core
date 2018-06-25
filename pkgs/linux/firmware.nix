{ config, lib, pkgs, ... }: 
{ 
  nixpkgs.overlays = [( self: super: { 
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-06-06";

      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "d1147327232ec4616a66ab898df84f9700c816c1";
        sha256 = "0xhbalf15isv7f0d5gfjaylillhkm7npr795riq65pz2aw66ralf";
      };
    }); 
  })];
}

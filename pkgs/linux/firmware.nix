{ config, lib, pkgs, ... }: 
{ 
  nixpkgs.overlays = [( self: super: { 
    firmwareLinuxNonfree = with super; firmwareLinuxNonfree.overrideAttrs(old: rec {
      name = "firmware-linux-nonfree-${version}";
      version = "2018-06-06";

      src = fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "8d69bab7a3da1913113ea98cefb73d5fa6988286";
        sha256 = "1ganxgkdxl10v0ihsp9qsaj4px8yf8kihz4gbmqyld28rqnc47zl";
      };
    }); 
  })];
}

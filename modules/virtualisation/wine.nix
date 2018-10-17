{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineStaging
    ((winetricks.overrideAttrs (old: rec {
      src = fetchFromGitHub rec {
        rev = "20180815";
        sha256 = "0ksz2jkpqq8vnsc511zag9zcx8486hs8mwlmkkygljc8ylb1ibn5";
        owner = "Winetricks";
        repo = "winetricks";
      };
    })).override {
      wine = wineStaging;
    })
  ];
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
}

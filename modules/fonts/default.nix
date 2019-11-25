{ config, options, lib, pkgs, ... }: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      nerdfonts
    ];
    fontconfig = {
      penultimate.enable = false;
      defaultFonts = {
        monospace = [ "MesloLGS Nerd Font" ];
        sansSerif = [ "Ubuntu" "DejaVu" ];
      };
    };
  };
}

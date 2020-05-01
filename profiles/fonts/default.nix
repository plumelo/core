{ config, options, lib, pkgs, ... }: {
  fonts = {
    fontconfig = {
      defaultFonts = {
        monospace = [ "DejaVuSansMono Nerd Font" ];
      };
    };
    fonts = with pkgs; [ nerdfonts_dejavu ];
  };
}

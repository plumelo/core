{ config, options, lib, pkgs, ... }: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [ overpass nerdfonts ];
    fontconfig = {
      penultimate.enable = false;
      defaultFonts = { monospace = [ "Hack Nerd Font Mono" ]; };
    };
  };
}

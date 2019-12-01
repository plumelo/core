{ config, options, lib, pkgs, ... }: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs;
      [
        (nerdfonts.overrideAttrs (old: rec {
          version = "2.1.0";
          src = fetchFromGitHub {
            owner = "ryanoasis";
            repo = "nerd-fonts";
            rev = "601e5a150f44a6ce17855c8576068a18154b289f";
            sha256 = "1myzs8zw13x56y2maz503fvcqrppcza667mn1wj5pnr99is3br98";
          };
        }))
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

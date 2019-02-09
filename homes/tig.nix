{ pkgs, ... }: {
  home.packages = [ pkgs.gitAndTools.tig ];
  xdg.configFile."tig/config".source = ./xdg/tig/config;
}

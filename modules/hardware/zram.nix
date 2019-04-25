{ config, lib, pkgs, ... }:
{
  zramSwap = {
    algorithm = "zstd";
    enable    = true;
    priority  = 6;
  };
}

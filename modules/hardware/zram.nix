{ config, lib, pkgs, ... }:
{
  zramSwap = {
    enable    = true;
    priority  = 6;
  };
}

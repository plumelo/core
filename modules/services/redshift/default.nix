{ config, lib, pkgs, ... }:
 {
  services.redshift = {
    package = pkgs.redshift-wlr;
  };
}

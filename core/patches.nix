{ writeText, fetchpatch }:
[
  (
    writeText "nixos-overlays-fix.patch" ''
      diff --git a/nixos/modules/misc/nixpkgs.nix b/nixos/modules/misc/nixpkgs.nix
      index afb74581e23..c8387aaf5ce 100644
      --- a/nixos/modules/misc/nixpkgs.nix
      +++ b/nixos/modules/misc/nixpkgs.nix
      @@ -56,10 +56,10 @@ let
         };

         defaultPkgs = import ../../.. {
      -    inherit (cfg) config overlays localSystem crossSystem;
      +    inherit (cfg) config localSystem crossSystem;
         };

      -  finalPkgs = if opt.pkgs.isDefined then cfg.pkgs.appendOverlays cfg.overlays else defaultPkgs;
      +  finalPkgs = if opt.pkgs.isDefined then cfg.pkgs.appendOverlays cfg.overlays else defaultPkgs.appendOverlays cfg.overlays;

       in
    ''
  )
  (fetchpatch rec {
    name = "97438";
    url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/${name}.diff";
    sha256 = "0l6rhplmsg53alwwj82m372nfw7bdkadfi90rgm5xic44j07vrf7";
  })
]

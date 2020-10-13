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
  (
    (fetchpatch {
      name = "99395.patch";
      url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/99395.diff";
      sha256 = "1vx1d4a8hp94jb6isgmyiyhhkzadyshri3h86ka1imz08xilislf";
    })
  )
]

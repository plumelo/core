{ writeText, fetchpatch }: [
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
    fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/87797.diff";
      sha256 = "14imhhaazf8vghdq0w2dwq0g4jxa3ljfph9aw6dc148r7rjmn7pj";

    }
  )
]

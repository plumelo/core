{ stdenv
, python2
, utillinux
, runCommand
, writeTextFile
, nodejs
, fetchurl
, fetchgit
, nodePackages
}:
let
  nodeEnv = import <nixpkgs/pkgs/development/node-packages/node-env.nix> {
    inherit stdenv python2 utillinux runCommand writeTextFile;
    inherit nodejs;
    libtool = null;
  };
  js = import ./node-packages.nix {
    inherit fetchurl fetchgit;
    inherit nodeEnv;
  };
in
js // {

  import-js = js.import-js.override {
    buildInputs = [ nodePackages.node-pre-gyp ];
  };
}

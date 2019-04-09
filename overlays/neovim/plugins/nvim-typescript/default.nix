{buildEnv, makeWrapper, fetchFromGitHub, lib, vimUtils, nodejs, pkgs}:
with vimUtils;

let
  nodeEnv = import <nixpkgs/pkgs/development/node-packages/node-env.nix> {
    inherit (pkgs) stdenv python2 utillinux runCommand writeTextFile;
    inherit nodejs;
    libtool = null;
  };
  nodePackages=  (import ./node-packages.nix {
    inherit (pkgs) fetchurl fetchgit;
    inherit nodeEnv;
  });
  nodeRuntimeEnv =  buildEnv {
    name= "nvim-typescript-node-env";
    paths = with lib; (filter (v: nixType v == "derivation") (attrValues nodePackages));
  };
in
  buildVimPlugin {
    pname= "nvim-typescript";
    version = "0.1";
    src = fetchFromGitHub {
      owner = "mhartington";
      repo = "nvim-typescript";
      rev = "eca2bb92d45f09fc500317ededace5bc849063c1";
      sha256 = "10lh0yn7r4dfw8nkhrl676aasidwdiiln7gs9ac27yw77xz8p5zp";
    };
    buildInputs = [nodejs];
    buildPhase = ''
      pushd rplugin/node/nvim_typescript
      ln -s ${nodeRuntimeEnv}/lib/node_modules ./node_modules
      npm run build
      popd
    '';
  }

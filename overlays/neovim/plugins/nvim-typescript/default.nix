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
      rev = "2fd4da80cd31cd0314b437a9f68b6536ec67b2a2";
      sha256 = "1hykl7q6f6qi54dmw4ggk1jzjizy9zy6inwkm24kxfafq8n79gh9";
    };
    buildInputs = [nodejs];
    buildPhase = ''
      pushd rplugin/node/nvim_typescript
      ln -s ${nodeRuntimeEnv}/lib/node_modules ./node_modules
      npm run build
      popd
    '';
  }

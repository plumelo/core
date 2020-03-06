{ lib
, callPackage
, vimPlugins
, vim-vint
, wrapNeovim
, neovim-unwrapped
, utf8proc
, makeWrapper
, fetchFromGitHub
, ag
, fd
, fzf
, git
, nodePackages
, nixpkgs-fmt
, editorconfig-core-c
, python37Packages
}:
let
  lsp = callPackage ./lsp {};
  neovimConfig = callPackage ./config {};
  neovim = wrapNeovim (
    neovim-unwrapped.overrideAttrs (
      old: rec {
        name = "neovim-unwrapped-${version}";
        version = "nightly";
        src = fetchFromGitHub {
          owner = "neovim";
          repo = "neovim";
          rev = "a2efc9cf8b0fdf14b01156ba424145e1847f789c";
          sha256 = "1d7i8087mjzbc9awqp3j0jr0pdn1k04kckml3wbbknws46fb27gx";
        };
        nativeBuildInputs = old.nativeBuildInputs ++ [ utf8proc makeWrapper ];
        postInstall = old.postInstall + ''
          wrapProgram $out/bin/nvim --prefix PATH : ${lib.makeBinPath
          [
            ag
            fzf
            git
            fd
            lsp.vim-language-server
            lsp.fixjson
            nodePackages.eslint
            nodePackages.eslint_d
            nodePackages.prettier
            nodePackages.typescript
            nodePackages.typescript-language-server
            nodePackages.vscode-html-languageserver-bin
            nodePackages.vscode-css-languageserver-bin
            nixpkgs-fmt
            vim-vint
            python37Packages.yamllint
            editorconfig-core-c
          ]
        }
        '';
      }
    )
  ) {
    withNodeJs = true;
    vimAlias = true;
    inherit (neovimConfig) configure;
  };
in
neovim.overrideAttrs (
  old: rec {
    buildCommand = ''
      export HOME=$TMPDIR
    '' + old.buildCommand;
  }
)

self: super:
with super;

let
  plugins = callPackage ./plugins/default.nix {};
in {
  neovim-unwrapped = (neovim-unwrapped
  .override {
    stdenv= gcc8Stdenv;
  })
  .overrideAttrs(old: rec {
    name = "neovim-unwrapped-${version}";
    version = "0.4.0-dev";
    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "974b43fd7940cd807e5a6b67c77cb2e0462b11a4";
      sha256 = "1hgvrcwi7dzzci7kg0l83pnd74syiwrqy4vkk2dd1s7daxlzrgvv";
    };
    NIX_CFLAGS_COMPILE = "-O3 -march=native";
  });

  neovim = neovim.override {
    withNodeJs = true;
    configure = {
      customRC = ''
        ${ callPackage ./autocmds.vim.nix {}}
        ${ callPackage ./options.vim.nix {}}
        ${ callPackage ./mappings.vim.nix {}}
        ${ callPackage ./configs.vim.nix {}}
        syntax enable
        set background=dark
        colorscheme onehalfdark
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          lightline-vim
          vinegar
          plugins.nvim-typescript
          vim-nix
        ];
        opt = [
          ale
          ack-vim
          commentary
          surround
          repeat
          vim-highlightedyank
          vim-signify
          editorconfig-vim
          vim-eunuch
          fugitive
        ]++ (with plugins; [
          starsearch
          onehalfdark
          quickfix
          largefile
          jsx
          yats
          twig
        ]);
      };
    };
  };
}

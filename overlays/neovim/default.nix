self: super:
with super;

let
  plugins = callPackage ./plugins/default.nix {};
in {
  neovim-unwrapped = (neovim-unwrapped
  .override {
    stdenv= gcc9Stdenv;
  })
  .overrideAttrs(old: rec {
    name = "neovim-unwrapped-${version}";
    version = "0.4.0-dev";
    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "16ee24082f72162d3bdfbddb0b40b5abc2c90fda";
      sha256 = "1hqharf1l4jgjwv76rjxislc3z3nmhqp52fx6dy58whll5rj2l6r";
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
          ale
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

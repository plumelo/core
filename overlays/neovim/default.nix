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
      rev = "24a9516ff41b69e649f0dac131ad20efbe19eb4b";
      sha256 = "101wx26ybs078wd5gd3dyxmmdflsb22cr1y9fp22nxidhvnnwlyw";
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
        ];
        opt = [
          ale
          ack-vim
          commentary
          surround
          repeat
          vim-highlightedyank
          vim-signify
          vim-nix
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

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
      rev = "052ced4954075eca360ff7689afea82252f1c599";
      sha256 = "1vzifx60yi3p37fy8fkc6icmzgf9abl3jbn65s1iizv2q5zdd7gf";
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
          polyglot
          fugitive
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
        ]++ (with plugins; [
          starsearch
          onehalfdark
          quickfix
          largefile
        ]);
      };
    };
  };
}

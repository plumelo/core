self: super:
with super;

let
  plugins = callPackage ./plugins/default.nix {};
in {
  neovim-unwrapped = neovim-unwrapped.overrideAttrs(old: rec {
    name = "neovim-unwrapped-${version}";
    version = "0.4.0-dev";
    src = fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "052ced4954075eca360ff7689afea82252f1c599";
      sha256 = "1vzifx60yi3p37fy8fkc6icmzgf9abl3jbn65s1iizv2q5zdd7gf";
    };
  });

  neovim = neovim.override {
    configure = {
      customRC = ''
        ${ callPackage ./options.vim.nix {}}
        ${ callPackage ./autocmds.vim.nix {}}
        ${ callPackage ./configs.vim.nix {}}
        ${ callPackage ./mappings.vim.nix {}}
        ${ callPackage ./fzf.vim.nix {}}
        syntax enable
        set background=dark
        colorscheme onehalfdark
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          lightline-vim
          polyglot
        ];
        opt = [
          ale
          ack-vim
          commentary
          surround
          repeat
          neoformat
          vim-highlightedyank
          vim-signify
          editorconfig-vim
          fugitive
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

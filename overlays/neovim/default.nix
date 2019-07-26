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
        if !v:vim_did_enter && has('reltime')
          let g:startuptime = reltime()
          augroup vimrc-startuptime
            autocmd! VimEnter * let g:startuptime = reltime(g:startuptime)
              \ | redraw
              \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
          augroup END
        endif

        augroup vimrc
          autocmd!
        augroup END

        """" large file
        let g:LargeFile = 20*1024*1024 " 20MB

        ${ callPackage ./options.vim.nix {}}
        ${ callPackage ./mappings.vim.nix {}}
        ${ callPackage ./autocmds.vim.nix {}}
        ${ callPackage ./configs.vim.nix {}}

        syntax enable
        filetype plugin indent on

        set background=dark
        colorscheme onehalfdark
      '';

      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          fugitive
          lightline-vim
          vinegar
          vim-nix
          rust-vim
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
          vim-coffee-script
          vim-jinja
          vim-markdown
          ale
          yats-vim
        ]++ (with plugins; [
          ale
          mergetool
          starsearch
          onehalfdark
          quickfix
          javascript_syntax
          jsx
          html_template
          twig
          auto-git-diff
        ]);
      };
    };
  };
}

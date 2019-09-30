self: super:
with super;

let plugins = callPackage ./plugins/default.nix { };

in {

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

        ${callPackage ./options.vim.nix { }}
        ${callPackage ./mappings.vim.nix { }}
        ${callPackage ./autocmds.vim.nix { }}
        ${callPackage ./configs.vim.nix { }}

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
          quickfix-reflector-vim
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
          vim-mergetool
          starsearch-vim
          vim-javascript-syntax
          vim-jsx-pretty
          vim-html-template-literals
          vim-twig
          auto-git-diff
        ] ++ (with plugins; [ onehalfdark ]);
      };
    };
  };
}

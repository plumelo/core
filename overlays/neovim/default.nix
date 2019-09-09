self: super:
with super;

let
  plugins = callPackage ./plugins/default.nix { };
  luv-dev = lua.pkgs.luv.override ({
    propagatedBuildInputs = [ libuv ];
    preBuild = ''
      sed -i 's,\(option(WITH_SHARED_LIBUV.*\)OFF,\1ON,' CMakeLists.txt
      sed -i 's,\(option(BUILD_MODULE.*\)ON,\1OFF,' CMakeLists.txt
      sed -i 's,$'' + ''
        {INSTALL_INC_DIR},${placeholder "out"}/include/luv,' CMakeLists.txt
             rm -rf deps/libuv
            '';
    postInstall = ''
      rm -rf $out/luv-*-rocks
    '';
  });
  neovimLuaEnv = lua.withPackages
    (ps: (with ps; [ compat53 lpeg luabitop luv luv-dev mpack ]));
in {
  neovim-unwrapped =
    (neovim-unwrapped.override { stdenv = gcc9Stdenv; }).overrideAttrs
    (old: rec {
      name = "neovim-unwrapped-${version}";
      version = "0.4.0-dev";
      src = fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "554566c";
        sha256 = "1vbsyrwrdfsdlypknh8pbq3ql1hs70g2fr1xyd1gmg7qkiqk2j46";
      };
      buildInputs = [
        libtermkey
        libuv
        msgpack
        ncurses
        libvterm-neovim
        unibilium
        gperf
        neovimLuaEnv
      ];
      cmakeFlags = [
        "-DGPERF_PRG=${gperf}/bin/gperf"
        "-DLUA_PRG=${neovimLuaEnv.interpreter}"
        "-DLIBLUV_LIBRARY=${luv-dev}/lib/lua/${lua.luaversion}/libluv.a"
        "-DLIBLUV_INCLUDE_DIR=${luv-dev}/include"
      ] ++ stdenv.lib.optional (!lua.pkgs.isLuaJIT) "-DPREFER_LUA=ON";
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

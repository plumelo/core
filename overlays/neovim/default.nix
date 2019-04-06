self: super:
with super;

let

  options = callPackage ./options/default.nix {
    inherit (vimUtils) buildVimPlugin;
  };

  mappings = callPackage ./mappings/default.nix {
    inherit (vimUtils) buildVimPlugin;
  };

  functions = callPackage ./functions/default.nix {
    inherit (vimUtils) buildVimPlugin;
  };

  configs = callPackage ./configs/default.nix {
    inherit (vimUtils) buildVimPlugin;
  };

  onehalfdark = callPackage ./onehalfdark/default.nix {
    inherit (vimUtils) buildVimPlugin;
  };

  quickfix = callPackage ./quickfix/default.nix {
    inherit (vimUtils) buildVimPlugin;
  };

  largefile = callPackage ./largefile/default.nix {
    inherit (vimUtils) buildVimPlugin;
  };

  starsearch = callPackage ./starsearch/default.nix {
    inherit (vimUtils) buildVimPlugin;
  };

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
        set encoding=utf-8
        scriptencoding utf-8

        " startup time
        if !v:vim_did_enter && has('reltime')
          let g:startuptime = reltime()
          augroup vimrc-startuptime
          autocmd! VimEnter * let g:startuptime = reltime(g:startuptime)
            \                 | redraw
            \                 | echomsg 'startuptime: ' . reltimestr(g:startuptime)
          augroup END
        endif

        " general group
        augroup MyAutoCmd
          autocmd!
        augroup END

        " default shell
        set shell=/usr/bin/env\ bash

        " ack plugin
        let g:ackprg = '${ag}/bin/ag --vimgrep'
        let g:ackhighlight = 1
        let g:ack_mappings = { 'o': '<CR>zz' }
        nnoremap <leader>f :<C-u>Ack!<CR>
        nnoremap <leader>g :<C-u>Ack!<Space>

        "fzf plugin
        set runtimepath+=${fzf.out}/share/vim-plugins/fzf*/

        function! ExternalizeErr(tmp,data,event, id)
        endfunction

        function! ExternalizeExit(tmp, action, id)
          if filereadable(a:tmp)
            let l:files = readfile(a:tmp)
            if type(a:action) == type(function('call'))
              call a:action(l:files)
            else
              for file in l:files
                call execute(a:action.' '.file)
              endfor
            endif
            exec ':silent !rm '.a:tmp
          endif
        endfunction

        function! Externalize(cmd, action)
          let l:tmp = tempname()
          let l:command = printf(a:cmd, l:tmp)
          let l:id = jobstart(l:command, {
            \  'on_exit': {id-> ExternalizeExit(l:tmp, a:action, l:id)},
            \  'on_stderr': {id, data,event -> ExternalizeErr(l:tmp, data,event, id)} ,
            \  'on_stdout': {id, data,event -> ExternalizeErr(l:tmp, data, event, id)} ,
            \  })
        endfunction

        let $FZF_DEFAULT_OPTS='--ansi --layout reverse'
        let g:fzf_layout = { 'down': '15' }
        let g:_fzf_command = 'fd --type file --follow --hidden --exclude .git'

        function! FZFD()
          let $FZF_DEFAULT_COMMAND = g:_fzf_command
          FZF
        endfunction

        command! F call FZFD()
        nnoremap <silent> <C-p> :F<CR>

        function! FZFL()
          let $FZF_DEFAULT_COMMAND = g:_fzf_command
          FZF %:h
        endfunction
        command! FZFL call FZFL()

        function! FZFDA()
          let $FZF_DEFAULT_COMMAND='fd -HI'
          FZF
        endfunction

        command! FZFDA call FZFDA()

        function! s:buflist()
          redir => ls
          silent ls
          redir END
          return split(ls, '\n')
        endfunction

        let g:buffer_action = {
              \ 'ctrl-x': 'sb',
              \ 'ctrl-v': 'vsp|b',
              \ 'ctrl-w': 'bdelete'
              \}

        function! BufferSink(lines)
          if len(a:lines)<2
            return
          endif
          let key = remove(a:lines, 0)
          let Cmd = get(g:buffer_action, key,'buffer')
          for line in a:lines
            let bid = matchstr(line, '^[ 0-9]*')
            execute Cmd bid
          endfor
        endfunction

        command! Buffers :call fzf#run(fzf#wrap(
              \{
              \   'source':  reverse(<sid>buflist()),
              \   'sink*':  function('BufferSink'),
              \   'options': '-m --expect='.join(keys(buffer_action), ',')
              \ }))

        noremap <Bs> :Buffers<CR>

        " ranger
        nnoremap <silent> =- :call Externalize('${self.alacritty}/bin/alacritty --class "ranger-menu" -e sh -c "ranger --choosefiles=%s '.getcwd().' && clear"; sleep 0.01',':silent ::e! ')<CR>
        nnoremap <silent> -  :call Externalize('${self.alacritty}/bin/alacritty --class "ranger-menu" -e sh -c "ranger --choosefiles=%s --selectfile='.expand("%:p").' '.expand("%:p:h").' && clear"; sleep 0.01',':silent ::e! ')<CR>

        " autocmds
        autocmd MyAutoCmd BufEnter * call timer_start(300, function('opt#plugins'))
        autocmd MyAutoCmd BufEnter * syntax sync fromstart
        autocmd MyAutoCmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | exe 'normal! g`"zz' | endif
        autocmd MyAutoCmd InsertEnter * set listchars-=trail:␣
        autocmd MyAutoCmd InsertLeave * set listchars+=trail:␣

        syntax enable

        if has('termguicolors')
          set termguicolors
        endif

        set background=dark
        colorscheme onehalfdark

      '';

        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [
            options
            configs
            functions
            fugitive
            gitgutter
            lightline-vim
            editorconfig-vim
            polyglot
          ];

          opt = [
            mappings
            ale
            ack-vim
            commentary
            surround
            repeat
            neoformat
            vim-highlightedyank
            starsearch
            onehalfdark
            quickfix
            largefile
          ];
        };

    };
  };

  vim-vint=  vim-vint.overridePythonAttrs(old: {
    checkPhase = false;
  });
}

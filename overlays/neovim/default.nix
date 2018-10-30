self: super: 
with super;
{
  neovim-unwrapped = neovim-unwrapped.overrideAttrs(old: rec {
  name = "neovim-unwrapped-${version}";
  version = "0.3.2-dev";
  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "nightly";
    sha256 = "0z4hpgkmr7yvx8zc0mqqj1gqhwkqqgm5gwr7cp7yfjqb5l9h8h98";
  };
  });
  neovim = neovim.override {
    configure = {
      customRC = ''
        set runtimepath+=${fzf.out}/share/vim-plugins/fzf*/
        source ~/.config/nvim/init.vim

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

        nnoremap <silent> - :call Externalize('termite -t "ranger-menu" -e "ranger --choosefiles=%s '.getcwd().'"',':silent ::e! ')<CR>
        nnoremap <silent> =- :call Externalize('termite -t "ranger-menu" -e "ranger --choosefiles=%s '.expand("%:p:h").'"',':silent ::e! ')<CR>

      '';
    };
  };
}

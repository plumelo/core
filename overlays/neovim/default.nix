self: super: 
with super;
{
  neovim-unwrapped = neovim-unwrapped.overrideAttrs(old: rec {
  name = "neovim-unwrapped-${version}";
  version = "0.3.2-dev";
  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "4a7f6dafe9e58315f90167ee41d279f3fa65eebb";
    sha256 = "1d46dcj71kmyjxvr8a3ijfr12l67vm19zaiv47dbvqy9ski3xw5d";
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

        nnoremap <silent> - :call Externalize('${self.alacritty}/bin/alacritty -t "ranger-menu" -e sh -c "ranger --choosefiles=%s '.getcwd().' && clear"; sleep 0.01',':silent ::e! ')<CR>
        nnoremap <silent> =- :call Externalize('${self.alacritty}/bin/alacritty -t "ranger-menu" -e sh -c "ranger --choosefiles=%s '.expand("%:p:h").' && clear"; sleep 0.01',':silent ::e! ')<CR>

      '';
    };
  };
}

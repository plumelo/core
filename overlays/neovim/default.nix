self: super: 
with super;
{
  neovim-unwrapped = neovim-unwrapped.overrideAttrs(old: rec {
  name = "neovim-unwrapped-${version}";
  version = "0.4.0-dev";
  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "5c836d2ef8b6b2a8ad1ea7e4d7e1bf8dd9b1b93d";
    sha256 = "031lpp0vrqwijlnmqlmlc7cvvslj7h3n87l5phw7nb326q2b610k";
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

        nnoremap <silent> - :call Externalize('${self.alacritty}/bin/alacritty --class "ranger-menu" -e sh -c "ranger --choosefiles=%s '.getcwd().' && clear"; sleep 0.01',':silent ::e! ')<CR>
        nnoremap <silent> =- :call Externalize('${self.alacritty}/bin/alacritty --class "ranger-menu" -e sh -c "ranger --choosefiles=%s --selectfile='.expand("%:p").' '.expand("%:p:h").' && clear"; sleep 0.01',':silent ::e! ')<CR>

      '';
    };
  };

  vim-vint=  vim-vint.overridePythonAttrs(old: {
    checkPhase = false;
  });
}

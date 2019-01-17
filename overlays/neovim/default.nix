self: super: 
with super;
{
  neovim-unwrapped = neovim-unwrapped.overrideAttrs(old: rec {
  name = "neovim-unwrapped-${version}";
  version = "0.3.2-dev";
  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "95fa71c6d2b4a2d86bc1e4a984efbd188fab1382";
    sha256 = "0j81shywafvzfar0p2x2r77sc4dx6k4prlfp38ish8vxig94r1k0";
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

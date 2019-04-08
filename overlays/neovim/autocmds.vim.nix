pkgs:
# vim: set syntax=vim:
''
" startup time
if !v:vim_did_enter && has('reltime')
  let g:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter * let g:startuptime = reltime(g:startuptime)
      \ | redraw
      \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

" general group
augroup MyAutoCmd
  autocmd!
augroup END

function g:LazyPlugins(...)
  packadd vim-repeat
  packadd vim-commentary
  packadd vim-surround
  packadd ack-vim
  packadd vim-highlightedyank
  packadd vim-visualstar
  packadd quickfix-vim
  packadd largefile-vim
  packadd ale
  packadd starsearch-vim

  packadd vim-signify
  packadd editorconfig-vim
  packadd vim-eunuch
endfunction

" autocmds
autocmd MyAutoCmd BufEnter * call timer_start(300, function('g:LazyPlugins'))
autocmd MyAutoCmd BufEnter * syntax sync fromstart
autocmd MyAutoCmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | exe 'normal! g`"zz' | endif
autocmd MyAutoCmd InsertEnter * set listchars-=trail:␣
autocmd MyAutoCmd InsertLeave * set listchars+=trail:␣
''

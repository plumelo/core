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
  packadd jsx-vim
  packadd yats-vim
  packadd twig-vim
  packadd vim-signify
  packadd editorconfig-vim
  packadd vim-eunuch
  packadd vim-fugitive
endfunction

" autocmds
augroup lazy_plugins
  autocmd!
  autocmd BufEnter * call timer_start(300, function('g:LazyPlugins'))
augroup END

augroup syntax_sync
  autocmd!
  autocmd BufEnter * syntax sync fromstart
augroup END

augroup remember_position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | exe 'normal! g`"zz' | endif
augroup END

augroup list_trail
autocmd!
  autocmd InsertEnter * set listchars-=trail:␣
  autocmd InsertLeave * set listchars+=trail:␣
augroup END
''

scriptencoding utf-8

" If a file is large, disable syntax highlighting, filetype etc
let g:LargeFile = 20*1024*1024 " 20MB
autocmd vimRc BufReadPre *
      \ let s = getfsize(expand("<afile>")) |
      \ if s > g:LargeFile || s == -2 |
      \   call functions#large_file(fnamemodify(expand("<afile>"), ":p")) |
      \ endif

" don't list location-list / quickfix windows
autocmd vimRc BufReadPost quickfix setlocal nobuflisted
autocmd vimRc BufReadPost quickfix nnoremap <buffer> gq :bd<CR>
autocmd vimRc FileType help nnoremap <buffer> gq :bd<CR>
autocmd vimRc CmdwinEnter * nnoremap <silent><buffer> gq :<C-u>quit<CR>

" grep.
autocmd vimRc QuickFixCmdPost cgetexpr cwindow

" qf and help keep widow full width
autocmd vimRc FileType qf wincmd J
autocmd vimRc BufWinEnter * if &ft == 'help' | wincmd J | end

" update diff
autocmd vimRc InsertLeave * if &l:diff | diffupdate | endif

" diff mappings
function! Diffmaps()
  nnoremap <buffer> zp :diffput<CR>
  nnoremap <buffer> zg :diffget<CR>
  vnoremap <buffer> zg :diffget<CR>
  vnoremap <buffer> zp :diffput<CR>
endfunction
autocmd vimRc BufEnter * if &diff | call Diffmaps() | endif

" external changes
autocmd vimRc FocusGained,CursorHold * if !bufexists("[Command Line]") | checktime | GitGutter | endif

" mkdir
autocmd vimRc BufWritePre *
      \ if !isdirectory(expand('%:h', v:true)) |
      \   call mkdir(expand('%:h', v:true), 'p') |
      \ endif

" kepp cursor position
autocmd vimRc BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

" fugitive files
autocmd vimRc FileType git setlocal nofoldenable

" hlsearch
highlight default link CurrentSearch IncSearch
command! -bar Nohlsearch ClearCurrentSearch | nohlsearch
command! -bar ClearCurrentSearch silent! call matchdelete(get(s:, 'current_search_id', -1))
function! HighlightCurrent() abort
  ClearCurrentSearch
  if get(v:, 'hlsearch', 0) == 1
    let pat = (&ignorecase && (!&smartcase || @/ !~# '\u')  ? '\c' : '\C') . '\m\%#' . (&magic ? '' : '\M') . @/
    let s:current_search_id = matchadd('CurrentSearch', pat, 10, get(s:, 'current_search_id', -1))
  endif
endfunction
autocmd vimRc CursorMoved,InsertLeave * call HighlightCurrent()

" filetype
autocmd vimRc BufNewFile,BufRead *.jsx setlocal filetype=javascript
autocmd vimRc BufReadPre,BufNewFile *.tsx setlocal filetype=typescript
autocmd vimRc BufNewFile,BufRead *.twig setlocal filetype=html.twig
autocmd vimRc BufRead,BufNewFile *.gitignore  setlocal filetype=gitignore
autocmd vimRc BufReadPre,BufNewFile *.twig setlocal filetype=twig.html
autocmd vimRc BufNewFile,BufRead config setlocal filetype=config
autocmd vimRc BufWinEnter *.json setlocal conceallevel=0 concealcursor=
autocmd vimRc BufReadPre *.json setlocal conceallevel=0 concealcursor=
autocmd vimRc BufReadPre *.json setlocal formatoptions=

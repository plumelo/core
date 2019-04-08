{ag}:
# vim: set syntax=vim:
''
" ack
let g:ackhighlight = 1
let g:ack_mappings = { 'o': '<CR>zz' }
let g:ackprg = '${ag}/bin/ag --vimgrep'
nnoremap <leader>f :<C-u>Ack!<CR>
nnoremap <leader>g :<C-u>Ack!<Space>

" lightline plugin
let g:lightline = {
  \ 'colorscheme': 'one',
  \ 'active': {
  \   'left':[ 
  \     [ 'mode', 'paste' ],
  \     [ 'gitbranch', 'readonly', 'filename', 'modified' ]
  \   ]
  \ },
  \ 'component': {
  \   'lineinfo': ' %3l:%-2v',
  \ },
  \ 'component_function': {
  \   'gitbranch': 'fugitive#head',
  \ }
  \}
let g:lightline.separator = {
  \ 'left': '', 'right': ''
  \}
let g:lightline.subseparator = {
  \ 'left': '', 'right': ''
  \}

" ale lint plugin
let g:ale_linters_explicit = 1
let g:ale_set_highlights = 0
let g:ale_sign_info = 'i'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_pattern_options_enabled = 1
let g:ale_pattern_options = {
  \ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
  \ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
  \}
let g:ale_fix_on_save = 1
let g:ale_sign_warning = '●'
let g:ale_sign_error = '●'
let g:ale_fixers = {
  \ 'javascript': ['eslint'],
  \ 'html': ['eslint']
  \}
let g:ale_linter_aliases = {
  \ 'html': 'javascript'
  \}
let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'yaml': ['yamllint'],
  \ 'vim': ['vint'],
  \ 'nix': ['nix'],
  \ 'html': ['elsint'],
  \ 'typescript': ['eslint','tsserver']
  \}
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" editorconfig plugin
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_max_line_indicator = 'none'

" highlight and yank plugin
let g:highlightedyank_highlight_duration = 300

" neoformat plugin
let s:local_prettier_eslint = findfile('node_modules/.bin/prettier-eslint', '.;')
if executable(s:local_prettier_eslint)
  let g:neoformat_javascript_prettiereslint = {
    \ 'exe': './node_modules/.bin/prettier-eslint',
    \ 'args': ['--stdin', '--stdin-filepath', '%:p'],
    \ 'stdin': 1,
    \ }
endif

" netrw
let g:netrw_localrmdir='rm -r'
let g:netrw_bufsettings = 'noma nomod nu nowrap ro nobl'
let g:netrw_sort_dotfiles_first = 1
let g:netrw_altfile = 1
let g:netrw_banner = 0

let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\(^\|\s\s\)ntuser\.\S\+'
function! InNetrw()
  nmap <buffer> <right> <cr>
  nmap <buffer> <left> -
  nmap <buffer> <tab> G<cr>
  nmap <buffer> l qf
  nmap <silent> <buffer> <Esc> :Rexplore<CR>
endfunction
autocmd MyAutoCmd FileType netrw call InNetrw()

function MyExplore()
  if !exists('w:my_netrw_entered')
    Explore
    let w:my_netrw_entered = 1
  else
    Rexplore
  endif
endfunction

nnoremap - :call MyExplore()<cr>
nnoremap <leader><leader> :Vexplore!<cr>

"fzf plugin
set runtimepath+=${fzf.out}/share/vim-plugins/fzf*/
let $FZF_DEFAULT_OPTS='--ansi --layout reverse'
let g:fzf_layout = { 'down': '15' }
let g:_fzf_command = '${fd}/bin/fd --type file --follow --hidden --exclude .git'

function! FZFD()
  let $FZF_DEFAULT_COMMAND = g:_fzf_command
  FZF
endfunction

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

nnoremap <silent> <C-p> :call FZFD()<CR>
noremap <Bs> :call fzf#run(fzf#wrap({
  \ 'source':  reverse(<sid>buflist()),
  \ 'sink*':  function('BufferSink'),
  \ 'options': '-m --expect='.join(keys(buffer_action), ',')
  \ }))<CR>

''


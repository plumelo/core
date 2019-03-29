scriptencoding utf-8

" ack
let g:ackhighlight = 1
let g:ack_mappings = { 'o': '<CR>zz' }
nnoremap <leader>f :<C-u>Ack!<CR>
nnoremap <leader>g :<C-u>Ack!<Space>

" lightline plugin
let g:lightline = {
      \   'colorscheme': 'wombat',
      \   'active': {
      \     'left':[ [ 'mode', 'paste' ],
      \              [ 'gitbranch', 'readonly', 'filename', 'modified' ]
      \     ]
      \   },
      \   'component': {
      \     'lineinfo': ' %3l:%-2v',
      \   },
      \   'component_function': {
      \     'gitbranch': 'fugitive#head',
      \   }
      \ }
let g:lightline.separator = {
      \   'left': '', 'right': ''
      \}
let g:lightline.subseparator = {
      \   'left': '', 'right': ''
      \}

" ale lint plugin
let g:ale_linters_explicit = 1
let g:ale_set_highlights = 0
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
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
      \ 'html': ['elsint']
      \}

" editorconfig plugin
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

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

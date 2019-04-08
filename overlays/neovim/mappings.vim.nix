pkgs:
# vim: set syntax=vim:
''
nnoremap <Space>n :nohlsearch<CR>
nnoremap j gj
nnoremap k gk
vnoremap > >gv
vnoremap < <gv
nnoremap <C-s> :update<CR>
inoremap <C-s> <Esc>:update<CR>
xnoremap <C-s> <C-C>:<C-u>update<CR>
nnoremap <expr> 0 virtcol('.') - 1 <= indent('.') && col('.') > 1 ? '0' : '_'
nnoremap <silent> <M--> :vertical resize +1<CR>
nnoremap <silent> <M-=> :vertical resize -1<CR>
vnoremap . :normal .<CR>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
inoremap <C-a> <Home>
inoremap <C-e> <End>
nnoremap <leader>s :%s/
vnoremap <leader>s :s/
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nnoremap <space><space> :tabnew %<CR>
nnoremap <space>q :close<CR>
nnoremap <Space>w viw"+p
nnoremap <Space>p :put+<CR>
nnoremap <Space>P :put!+<CR>
vnoremap <Space>y "+y
vnoremap <Space>p "+p
vnoremap <Space>P "+P
nnoremap n nzzzv
nnoremap N Nzzzv
''

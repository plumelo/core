pkgs:
# vim: set syntax=vim:
''
set encoding=utf-8
scriptencoding utf-8

set number
set mouse=a
set cursorline
set lazyredraw
set noswapfile
set shortmess+=I
set noshowmode
set nowrap
set splitbelow
set splitright
set switchbuf=useopen,usetab
set completeopt+=menuone
set completeopt+=noinsert
set completeopt+=noselect
set omnifunc=syntaxcomplete#Complete
set completefunc=syntaxcomplete#Complete
set complete=.,w,b,u,U,t,i,d,k
set pumheight=10
set gdefault
set hlsearch|nohlsearch
set nostartofline
set sidescrolloff=5
set sidescroll=1
set expandtab
set smarttab
set softtabstop=2
set tabstop=2
set shiftwidth=2
set shiftround
set inccommand=nosplit
set updatetime=500
set list listchars=tab:▷\ ,space:·,extends:»,precedes:«,nbsp:⦸
set statusline=2
set wildmode=longest:full,full

if has('termguicolors')
  set termguicolors
endif
''

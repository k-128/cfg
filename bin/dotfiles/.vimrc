" Theming
" -----------------------------------------------------------------------------
syntax on
set encoding=UTF-8
set termguicolors
set background=dark

" Config, ':h <cmd>'
" -----------------------------------------------------------------------------
set noswapfile
set nobackup
set nowritebackup
set updatetime=1000  " (ms)
set mouse=a          " a: 'All modes'
set scrolloff=5      " Scroll range (lines)

" Visual
set number           " Show lines numbers
set relativenumber   " - Relative to the active line
set hlsearch         " Highlight search, to unset: :nohl
set wrap!            " Set word wrap
set colorcolumn=80
set showtabline=2
set visualbell
set t_vb=            " Set visual bell effect to nothing
"set list lcs=space:·,tab:\|·,trail:~,extends:>,precedes:<

" Edition
filetype indent on
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

" File specific
autocmd Filetype python           setlocal shiftwidth=4 ts=4 sw=4 expandtab
autocmd FileType typescript       setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType typescriptreact  setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript       setlocal shiftwidth=2 softtabstop=2 expandtab
autocmd Filetype html             setlocal ts=2 sw=2 expandtab

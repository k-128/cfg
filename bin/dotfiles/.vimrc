"set nocompatible

" Plugs
" -----------------------------------------------------------------------------
call plug#begin("~/.vim/plugged")
" explorer
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'Xuyuanp/nerdtree-git-plugin'

" theming
Plug 'junegunn/seoul256.vim'
Plug 'joshdick/onedark.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'sainnhe/sonokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'

" syntax
Plug 'sheerun/vim-polyglot'
"Plug 'HerringtonDarkholme/yats.vim'
"Plug 'pangloss/vim-javascript'      " js
Plug 'leafgarland/typescript-vim'    " ts
"Plug 'maxmellon/vim-jsx-pretty'     " jsx, tsx
Plug 'peitalin/vim-jsx-typescript'

" completion
" Plug 'neovim/nvim-lspconfig'  # Then install LS manually
" https://github.com/nvim-lua/completion-nvim>

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" let g:coc_global_extensions = [
"   \  'coc-tsserver',
"   \  'coc-rls',
"   \  'coc-python',
"   \  'coc-list',
"   \  'coc-yaml',
"   \]

" Plug 'Valloric/YouCompleteMe'
" cd ~/.vim/plugged/YouCompleteMe './install.py --ts-completer'

"PlugInstall
call plug#end()


" Themes
" -----------------------------------------------------------------------------
syntax on
set encoding=UTF-8
set termguicolors
set background=dark

"let ayucolor                              = 'dark'  " 'dark', 'light', 'mirage'
"color ayu

" 'h: sonokai.txt'
let g:sonokai_style                       = 'atlantis'
let g:sonokai_transparent_background      = 1
let g:sonokai_sign_column_background      = 'none'
let g:sonokai_enable_italic               = 0
let g:sonokai_disable_italic_comment      = 1
"let g:sonokai_cursor                      = 'orange'
"let g:sonokai_menu_selection_background   = 'green'
"let g:sonokai_diagnostic_text_highlight   = 1
"let g:sonokai_diagnostic_line_highlight   = 1
color sonokai

" 'h: vim-airline'
let g:airline_theme                       = 'sonokai'  " 'ayu_dark', 'sonokai'
let g:airline#extensions#tabline#enabled  = 1
let g:airline_powerline_fonts             = 1
let g:airline_left_sep                    = "\uE0B8"
let g:airline_right_sep                   = "\uE0BA"
"let g:airline_left_alt_set                = 
"let g:airline_right_alt_sep               = 

" 'h: indentLine'
let g:indentLine_char                     = '¦'
let g:indentLine_showFirstIndentLevel     = 1
let g:indentLine_first_char               = '|'  "▏, |
let g:indentLine_char_list                = ['¦', '|']  " ⎸, ¦, │
let g:indentLine_leadingSpaceEnabled      = 1
let g:indentLine_leadingSpaceChar         = '·'  " •, ·, ˽, ˰, ·
let g:indentLine_setColors                = 1
let g:indentLine_color_gui                = "#4A4A4A"
" Handle conceal modified by indentLine
let g:vim_json_syntax_conceal             = 0
let g:vim_markdown_conceal                = 0
let g:vim_markdown_conceal_code_blocks    = 0

" Config, ':h <cmd>'
" -----------------------------------------------------------------------------
set noswapfile
set nobackup         " coc server issues
set nowritebackup    " coc server issues
set updatetime=1000  " ms
set mouse=a          " a: 'all modes'
set scrolloff=5

" Visual
set number
set relativenumber
set hlsearch  " ':noh' to unset highlight
set wrap!
set colorcolumn=80
set showtabline=2
set visualbell
set t_vb=  " Set visual bell effect to nothing
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

" Plugs
" Open NERD Tree when no file is specified
autocmd StdinReadPre * let s:std_in=1
if argc() == 0 && !exists("s:std_in")
    " NERDTreeToggle
    NERDTree

    " Keep NERD Tree open in new tabs
    autocmd BufWinEnter * NERDTreeMirror
    let NERDTreeShowHidden=1

    " " Close vim if only NerdTree left
    " autocmd BufEnter *
    " if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree())
    "     q
    " endif
endif


" let g:yats_host_keyword = 1
" set re=0
"let g:coc_disable_startup_warning = 1
"let g:coc_global_extensions=['coc-tsserver']  " files must be on wsl
"set cmdheight=6
let python_highlight_all=1


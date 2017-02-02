call plug#begin('~/.vim/plugged')

Plug 'taketwo/vim-ros'
Plug 'vim-syntastic/syntastic'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set smartcase

set autoindent
set mouse=a
set number
set nowrap
set lines=200
set ignorecase

set shiftwidth=4
set softtabstop=4
set expandtab
set tabstop=4

syntax enable

set showcmd
set cmdheight=1

set incsearch
set hlsearch

set paste

colorscheme molokai
let g:molokai_original = 1

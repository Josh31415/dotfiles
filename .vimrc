call plug#begin('~/.vim/plugged')

Plug 'taketwo/vim-ros'
Plug 'vim-jsx'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:go_fmt_command = "goimports"
let g:jsx_ext_required = 0
let g:clang_format#command="clang-format-4.0"
let s:nomodeline = 0

autocmd FileType java ClangFormatAutoEnable

set smartcase

set autoindent
set mouse=a
set number
set lines=200
set ignorecase

set shiftwidth=4
set softtabstop=4
set expandtab
set tabstop=4

set noswapfile
set lines=50 columns=100
set paste

syntax enable


colorscheme molokai
let g:molokai_original = 1

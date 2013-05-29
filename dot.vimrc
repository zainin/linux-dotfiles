set rtp+=/usr/lib/python3.3/site-packages/powerline/bindings/vim/
set fo=tcq
set modeline
set backupdir=~/.vim/backup/tmp
filetype plugin on
syntax on
set tabstop=2
set hlsearch
set ignorecase
set smartcase
set number
set autoindent
set nocompatible
set title
let &titleold='urxvt'

set expandtab
set softtabstop=2
set shiftwidth=2

colorscheme molokai

highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
match LiteralTabs /\s\	/
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

highlight OverLength ctermfg=red
match OverLength /\%81v.\+/

highlight comment ctermfg=cyan

set ruler
set laststatus=2
set guifont=Anonymous\ Pro\ for\ Powerline

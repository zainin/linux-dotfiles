set fo=tcq
set modeline
set backupdir=~/.vim/backup
"filetype plugin on
syntax on
set tabstop=2

"highlight search
set hlsearch
"and turn it off with '\<space>'
nnoremap <leader><space> :nohlsearch<CR>
"ignore search case
set ignorecase
"but not if you search for uppercase
set smartcase
"search as you type
set incsearch

"line numbers in column
set number

"folding!
set foldenable
"open most folds when opening file
set foldlevelstart=20
"don't nest them too much
set foldnestmax=10
"fold based on indent
set foldmethod=indent
"fold with space!
nnoremap <space> za

"get rid of those pesky trailing whitespaces
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

set autoindent
set nocompatible
set title
let &titleold='urxvt'

"set expandtab
"tab width
set softtabstop=2
set shiftwidth=2

"visual autocomplete for vim commands
set wildmenu

"redraw only when have to
set lazyredraw

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'bling/vim-airline'
Plugin 'gmarik/Vundle.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'matchit.zip'

call vundle#end()
filetype plugin indent on

colorscheme badwolf

highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
match LiteralTabs /\s\	/
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

highlight OverLength ctermfg=red
match OverLength /\%81v.\+/

highlight comment ctermfg=cyan

set ruler
set laststatus=2
set guifont=Inconsolata\ for\ Powerline

"reindent file
map <F7> mzgg=G`z<CR>

"indentLine config
let g:indentLine_color_term = 239
let g:indentLine_char = '┆'

"vim-airline config
let g:airline_powerline_fonts = 1
let g:airline_theme='badwolf'

"rainbow_parentheses
au VimEnter * RainbowParenthesesToggle

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

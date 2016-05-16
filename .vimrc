set fo=tcq
set modeline
set backupdir=~/.vim/backup
syntax on

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

"spaces instead of tabs
set expandtab
"tab width
set softtabstop=2
set tabstop=2
"reindent shift
set shiftwidth=2

"visual autocomplete for vim commands
set wildmenu

"redraw only when have to
set lazyredraw

"keep some context near cursor
set scrolloff=5

filetype plugin indent on
"filetype plugin on

call plug#begin('~/.vim/plugged')
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'Yggdroot/indentLine'
  Plug 'scrooloose/syntastic'
  Plug 'Valloric/YouCompleteMe'
"  Plug 'scrooloose/nerdtree'
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
  Plug 'vim-scripts/matchit.zip'
  Plug 'ntpeters/vim-better-whitespace'
  Plug 'majutsushi/tagbar'
  Plug 'jiangmiao/auto-pairs'
  Plug 'alvan/vim-closetag'
  Plug 'chrisbra/Colorizer'
call plug#end()

let g:rehash256 = 0
let g:molokai_original = 1
colorscheme molokai

"highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
"match LiteralTabs /\s\	/
"highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
"match ExtraWhitespace /\s\+$/
"match ExtraWhitespace /\s\+\%#\@<!$/
"au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"au InsertLeave * match ExtraWhitespace /\s\+$/

"highlight OverLength ctermfg=red
"match OverLength /\%81v.\+/

"highlight comment ctermfg=cyan

set ruler
set laststatus=2

"reindent file
map <F7> mzgg=G`z<CR>

"indentLine config
"︙ │ ┆
let g:indentLine_color_term = 239
let g:indentLine_char = '│'

let g:indentLine_color_term = 239

"vim-airline config
let g:airline_powerline_fonts = 1
let g:airline_theme='badwolf'
let g:airline#extensions#tabline#enabled = 1

let g:syntastic_python_checkers = ['flake8']
let g:syntastic_tex_checkers = ['chktex']
"rainbow_parentheses
"au VimEnter * RainbowParenthesesToggle

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
autocmd Filetype lua setlocal ts=4 sts=4 sw=4

"let g:indent_guides_auto_colors = 0
":hi IndentGuidesOdd ctermbg=236
":hi IndentGuidesEven ctermbg=240
"let g:indent_guides_start_level=2
"let g:indent_guides_guide_size=1
"let g:rainbow_active = 1

" terminal width warning
let &colorcolumn="80,".join(range(120,999),",")

map <C-n> :NERDTreeToggle<CR>
map <C-t> :TagbarToggle<CR>
map <C-e> :Errors<CR>

" gui options
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=Hermit\ 9

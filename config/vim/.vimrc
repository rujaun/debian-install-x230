set nocompatible
filetype off
set number

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'hynek/vim-python-pep8-indent'
Plug 'vim-airline/vim-airline'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'jiangmiao/auto-pairs'
Plug 'Valloric/YouCompleteMe'
Plug 'ryanoasis/vim-devicons'
Plug 'avakhov/vim-yaml'
Plug 'sickill/vim-pasta'
Plug 'arcticicestudio/nord-vim'

call plug#end()

let loaded_netrwPlugin = 1

filetype plugin indent on
syntax on
set backspace=indent,eol,start
set tabstop=2
set shiftwidth=2
set expandtab
set ai
set hlsearch
set ruler
set encoding=utf-8
set mouse=a
colorscheme nord

map <C-n> :NERDTreeToggle<CR>

autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | wincmd p | ene | exe 'NERDTree' argv()[0] | endif
let NERDTreeIgnore = ['__pycache__', '\.pyc$', '\.o$', '\.so$', '\.a$', '\.swp', '*\.swp', '\.swo', '\.swn', '\.swh', '\.swm', '\.swl', '\.swk', '\.sw*$', '[a-zA-Z]*egg[a-zA-Z]*', '.DS_Store']
let NERDTreeShowHidden=1
let g:NERDTreeMouseMode=2
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

let g:airline_powerline_fonts = 1
let python_highlight_all=1
let g:indent_guides_enable_on_vim_startup = 1
nnoremap <leader>p p`[v`]=
map <C-i> gt

set termguicolors
"set t_Co=256

set background=dark

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

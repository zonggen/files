" https://github.com/junegunn/vim-plug/wiki/tips
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" https://github.com/junegunn/vim-plug
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" https://github.com/airblade/vim-gitgutter
Plug 'airblade/vim-gitgutter'
" https://vimawesome.com/plugin/json-vim
Plug 'elzr/vim-json'
" https://github.com/plasticboy/vim-markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" https://github.com/flazz/vim-colorschemes
Plug 'flazz/vim-colorschemes'
" https://vimawesome.com/plugin/vim-fish
Plug 'dag/vim-fish'
" https://github.com/frazrepo/vim-rainbow
Plug 'frazrepo/vim-rainbow'
" https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'
" https://github.com/preservim/nerdcommenter
Plug 'preservim/nerdcommenter'
" https://github.com/Yggdroot/indentLine
Plug 'Yggdroot/indentLine'
" https://github.com/ntpeters/vim-better-whitespace
Plug 'ntpeters/vim-better-whitespace'
" https://github.com/Xuyuanp/nerdtree-git-plugin
Plug 'Xuyuanp/nerdtree-git-plugin'
" https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Initialize plugin system
call plug#end()

set scrolloff=5
set laststatus=2
set t_Co=256
set number relativenumber
set linebreak
set showbreak=+++
set textwidth=100
set showmatch
set visualbell
set hlsearch
set smartcase
set ignorecase
set incsearch
set autoindent
set cindent
set smartindent
set ruler
set undolevels=1000
set backspace=indent,eol,start
set laststatus=2
set showtabline=2
set noshowmode
set cursorline
set splitbelow
" Show tab as a |: https://github.com/Yggdroot/indentLine
set list lcs=tab:\¦\ 
syntax on
colorscheme wombat

" Tab settings:
" References:
" https://stackoverflow.com/questions/234564/tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim/21323445#21323445
" https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces#:~:text=Always%20keep%20'tabstop'%20at%208,4%20(or%203)%20characters.
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use filetype detection and file-based automatic indenting.
    filetype plugin indent on

    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif

" For everything else, use a tab width of 4 space chars.
set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.
set shiftwidth=4    " Indents will have a width of 4.
set softtabstop=4   " Sets the number of columns for a TAB.
set expandtab       " Expand TABs to spaces.
set smarttab

" Enable vim-rainbow
let g:rainbow_active = 1

" Custom shortcuts
map <C-n> :NERDTreeToggle<CR>
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <C-j> :tabprevious<CR>
nnoremap <C-k> :tabnext<CR>

" Show spaces as dots
let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled='1'
let g:indentLine_char = '¦'


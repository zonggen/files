" Vundle script starts here
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" My own plugins
Plugin 'airblade/vim-gitgutter'
" https://vimawesome.com/plugin/json-vim
Plugin 'elzr/vim-json'
" https://github.com/plasticboy/vim-markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
" https://github.com/flazz/vim-colorschemes
Plugin 'flazz/vim-colorschemes'
" https://vimawesome.com/plugin/bash-support-vim
Plugin 'bash-support.vim'
" https://vimawesome.com/plugin/vim-fish
Plugin 'dag/vim-fish'
" https://github.com/frazrepo/vim-rainbow
Plugin 'frazrepo/vim-rainbow'
" https://github.com/preservim/nerdtree
Plugin 'preservim/nerdtree'
" https://github.com/preservim/nerdcommenter
Plugin 'preservim/nerdcommenter'
" https://github.com/Yggdroot/indentLine
Plugin 'Yggdroot/indentLine'
" https://github.com/ntpeters/vim-better-whitespace
Plugin 'ntpeters/vim-better-whitespace'
" https://github.com/Xuyuanp/nerdtree-git-plugin
Plugin 'Xuyuanp/nerdtree-git-plugin'
" https://github.com/itchyny/lightline.vim
" Plugin 'itchyny/lightline.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
set rtp+=/usr/local/lib/python3.7/site-packages/powerline/bindings/vim/
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
set termwinsize=10x0
" Show tab as a |: https://github.com/Yggdroot/indentLine
set list lcs=tab:\¦\ 
syntax on
colorscheme molokai

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

if &term =~ '^screen'
      " tmux will send xterm-style keys when its xterm-keys option is on
      execute "set <xUp>=\e[1;*A"
      execute "set <xDown>=\e[1;*B"
      execute "set <xRight>=\e[1;*C"
      execute "set <xLeft>=\e[1;*D"
endif

" Enable vim-rainbow
let g:rainbow_active = 1
" Custom shortcuts
map <C-n> :NERDTreeToggle<CR>
" Show spaces as dots
let g:indentLine_leadingSpaceChar='·'
let g:indentLine_leadingSpaceEnabled='1'
let g:indentLine_char = '¦'

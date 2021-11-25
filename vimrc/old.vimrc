set nocompatible              " be iMproved, required
filetype off                  " required


" ------------------------
"  Vundle Settings
" ------------------------

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'derekwyatt/vim-scala'
Plugin 'scrooloose/syntastic'
Plugin 'altercation/vim-colors-solarized'
Plugin 'elixir-lang/vim-elixir'
Plugin 'rust-lang/rust.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'tomasiser/vim-code-dark'
Plugin 'brgmnn/vim-opencl'
Plugin 'vhda/verilog_systemverilog.vim'
Plugin 'https://github.com/junegunn/fzf.vim'
Plugin 'hashivim/vim-terraform'
Plugin 'YouCompleteMe'

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


" ------------------------
" Standard Settings
" ------------------------

" Use Vim settings, rather then Vi settings (much better!).

set nocompatible

" Turn on the verboseness to see everything vim is doing.
"set verbose=9

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set <BS>=
" I like 4 spaces for indenting
set shiftwidth=4

" I like 4 stops
set tabstop=4

" Soft Tab Stops
set softtabstop=4

" Spaces instead of tabs
set expandtab

" Always  set auto indenting on
set autoindent

" Create a C Indent
set cindent

" select when using the mouse
set selectmode=mouse


" set the commandheight
set cmdheight=2

" do not keep a backup files 
set nobackup
set nowritebackup

" Set 52 lines for the display, 1 for the status line.
" and other display options
if has('gui_running')
    " i like about 80 character width lines

  set textwidth=78
  "  2 for the command line
  set lines=52
  " add columns for the Project plugin

  set columns=110
  " enable use of mouse
  set mouse=a
endif

" keep 50 lines of command line history
set history=50

" show the cursor position all the time
set ruler

" show (partial) commands

set showcmd

" do incremental searches (annoying but handy);
set incsearch

" show the line numbers
set number

set hlsearch

"set clipboard=unnamedplus

" Show  tab characters. Visual Whitespace.
"set list

"set listchars=tab:>.

" Set ignorecase on
"set ignorecase

" smart search (override 'ic' when pattern has uppers)

"set scs

" for python: Modified on June1/2013
syntax enable
syntax on
filetype indent plugin on
set modeline 
set background=light

"
" Syntastic controlling syntax check
"
let g:syntastic_mode_map = {"mode" : "active", 
            \ "active_filetypes" : ["ruby", "php"],
            \ "passive_filetypes" : ["scala", "cpp", "java", "rust", "c", "python"]}

"colorscheme monokai
"colorscheme codedark

"
" vim-airline configuration
"
"colorscheme one-dark
"let g:airline_powerline_fonts=1
"let g:airline_theme = 'codedark'
"set t_Co=256
"let g:airline_theme='one'
"colorscheme one
"set background=dark

" ------------------------
" Sgrgregergrolarized color scheme
" ------------------------
"syntax enable
"set background=light
"colorscheme solarized

" ------------------------
" Syntastic settings
" ------------------------

" cpp advanced highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_template_highlight = 1

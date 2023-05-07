function InitVundle()
    let &compatible = 0
    let &filetype = 0
    let &rtp .= "," . "~/.vim/bundle/Vundle.vim"

    call vundle#begin()
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
    Plugin 'https://github.com/ycm-core/YouCompleteMe'
    Plugin 'peterhoeg/vim-qml'
    call vundle#end()

    " TODO how does this work???
    filetype plugin indent on
endfunction

function InitGlobalSettings()
	let &compatible = 0

    " TODO these 2 do not work with let &...
    set backspace=indent,eol,start
    "set <BS>=^?

	let &shiftwidth = 4
	let &tabstop = 4
	let &softtabstop = 4
	let &expandtab = 1
	let &autoindent = 1
	let &cindent = 1
    let &selectmode = &mouse
    let &cmdheight = 2
    let &backup = 0
    let &writebackup = 0
    let &history = 50
    let &ruler = 1
    let &showcmd = 1
    let &incsearch = 1
    let &number = 1
    let &hlsearch = 1

    " TODO understand these guys
    syntax enable
    syntax on
    filetype indent plugin on
    set modeline
    set background=light
    " TODO why above works, and below does not
    "let &background= &light

endfunction

function InitCppSyntaxHighlightingSettings()
    let g:cpp_class_scope_highlight = 1
    let g:cpp_member_variable_highlight = 1
    let g:cpp_class_decl_highlight = 1
    let g:cpp_experimental_template_highlight = 1
    let g:cpp_attributes_highlight = 1
    let g:cpp_class_scope_highlight = 1
    let g:cpp_concepts_highlight = 1
endfunction()

function InitYcmSettings()
    let g:ycm_auto_trigger = 1
    let g:ycm_confirm_extra_conf = 0 " TODO to be revisited
    let g:ycm_use_clangd = 1
endfunction()

" https://stackoverflow.com/questions/3682582/how-to-use-only-tab-not-space-in-vim
function ForceNoSpaces()
    set noet ci pi sts=0 sw=4 ts=4
endfunction

" main entry point - just a convention
function Main()
    call InitVundle()
    call InitGlobalSettings() 
    call InitCppSyntaxHighlightingSettings()
    call InitYcmSettings()
endfunction

call Main()

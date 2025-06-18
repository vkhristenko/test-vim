" =====================
" Plugin management
" =====================
" Initializes Vundle and declares all plugins used in this configuration.
function InitVundle()
    " Initialize Vundle and declare plugins
    let &compatible = 0
    let &filetype = 0
    let &rtp .= "," . "~/.vim/bundle/Vundle.vim"

    call vundle#begin()

    " === Vundle itself ===
    Plugin 'VundleVim/Vundle.vim'           " Vundle plugin manager

    " === Git and workflow ===
    Plugin 'tpope/vim-fugitive'             " Git integration
    Plugin 'L9'                             " Miscellaneous functions (dependency for some plugins)
    " Plugin 'git://git.wincent.com/command-t.git' " Command-T file finder (commented out)
    Plugin 'rstacruz/sparkup', {'rtp': 'vim/'} " HTML/JS rapid coding

    " === Language support ===
    Plugin 'derekwyatt/vim-scala'           " Scala language support
    Plugin 'elixir-lang/vim-elixir'         " Elixir language support
    Plugin 'rust-lang/rust.vim'             " Rust language support
    Plugin 'peterhoeg/vim-qml'              " QML language support
    Plugin 'brgmnn/vim-opencl'              " OpenCL language support
    Plugin 'vhda/verilog_systemverilog.vim' " Verilog/SystemVerilog support
    Plugin 'hashivim/vim-terraform'         " Terraform support

    " === Code completion and linting ===
    Plugin 'scrooloose/syntastic'           " Syntax checking
    Plugin 'https://github.com/ycm-core/YouCompleteMe' " Code completion engine

    " === UI and navigation ===
    Plugin 'scrooloose/nerdtree'            " File tree explorer
    Plugin 'vim-airline/vim-airline'        " Status/tabline
    Plugin 'vim-airline/vim-airline-themes' " Themes for airline
    Plugin 'octol/vim-cpp-enhanced-highlight' " Enhanced C++ syntax highlighting
    Plugin 'tomasiser/vim-code-dark'        " Code Dark color scheme
    Plugin 'altercation/vim-colors-solarized' " Solarized color scheme
    Plugin 'https://github.com/junegunn/fzf.vim' " Fuzzy file finder

    " === Copilot and AI ===
    Plugin 'https://github.com/github/copilot.vim.git' " GitHub Copilot
    Plugin 'vkhristenko/vim-test-plugin'    " Custom test plugin
    Plugin 'https://github.com/vkhristenko/vim-copilot.git' " Custom Copilot fork
    Plugin 'https://github.com/DanBradbury/copilot-chat.vim' " Copilot Chat

    call vundle#end()
endfunction

" =====================
" General Vim settings
" =====================
" Sets up general editing, UI, and shell options for Vim.
function InitGlobalSettings()
    " Set general editing and UI options
    filetype plugin indent on
	let &compatible = 0

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

    let &selectmode = &mouse

    syntax enable
    syntax on
    set modeline
    set background=light

    set shell=/bin/bash

endfunction

" =====================================
" C++ Syntax Highlighting Customization
" =====================================
" Enables advanced C++ syntax highlighting features for better code readability.
function InitCppSyntaxHighlightingSettings()
    " Enable advanced C++ syntax highlighting features
    let g:cpp_class_scope_highlight = 1
    let g:cpp_member_variable_highlight = 1
    let g:cpp_class_decl_highlight = 1
    let g:cpp_experimental_template_highlight = 1
    let g:cpp_attributes_highlight = 1
    let g:cpp_class_scope_highlight = 1
    let g:cpp_concepts_highlight = 1
endfunction()

" =====================
" YouCompleteMe Settings
" =====================
" Configures the YouCompleteMe plugin for code completion.
function InitYcmSettings()
    " Configure YouCompleteMe plugin options
    let g:ycm_auto_trigger = 1
    let g:ycm_confirm_extra_conf = 0 " TODO to be revisited
    let g:ycm_use_clangd = 1
endfunction()

" =====================
" Utility Functions
" =====================
" Forces Vim to use tabs instead of spaces for indentation.
function ForceNoSpaces()
    " Force tabs instead of spaces for indentation
    set noet ci pi sts=0 sw=4 ts=4
endfunction

" =====================
" Comment out selection with custom string
" Improved: Only comment lines not already commented
" Usage: visually select lines, then :call CommentSelection('//')
" Comments out each selected line with the given string, skipping lines already commented.
function! CommentSelection(commentstr)
    let l:start = line("'<")
    let l:end = line("'>")
    for lnum in range(l:start, l:end)
        let l:line = getline(lnum)
        " Check if the line is already commented
        if l:line !~ '^' . escape(a:commentstr, '\/*.^%~[')'
            " Add comment string at the beginning of the line
            call setline(lnum, a:commentstr . l:line)
        endif
endfunction

" =====================
" Split window into N vertical splits
" Usage: :call SplitWindowIntoN(3)
" Splits the current window into N vertical splits.
function! SplitWindowIntoN(n)
    for i in range(1, a:n-1)
        vsplit
    endfor
endfunction

" =====================
" Key Remaps and Leader Shortcuts
" Sets up custom key mappings for commenting and window management.
function InitRemaps()
    let mapleader = '\'
    vmap <leader>/ :<C-u>call CommentSelection('// ')<CR>
    vmap <leader" :<C-u>call CommentSelection('" ')<CR>
    vmap <leader# :<C-u>call CommentSelection('# ')<CR>

    nnoremap <leader>vs6 :call SplitWindowIntoN(6)<CR>
    nnoremap <leader>vs3 :call SplitWindowIntoN(3)<CR>
endfunction

" =====================
" Main entry point
" =====================
" Calls all initialization functions to set up the Vim environment.
function Main()
    call InitVundle()
    call InitGlobalSettings() 
    call InitCppSyntaxHighlightingSettings()
    call InitYcmSettings()
    call InitRemaps()
endfunction

" Automatically run main on startup
call Main()

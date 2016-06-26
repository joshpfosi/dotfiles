" prevents backwards compatibility with vi
set nocompatible

" filetypes woohoo - off for vundle
filetype off

" Vundle setup
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/vundle'

Plugin 'editorconfig/editorconfig-vim'
" adds support for .editorconfig files

Plugin 'pangloss/vim-javascript'
" Javascript indent plugin

Plugin 'Raimondi/delimitMate'
" auto-close brackets, quotes, etc.

" Latex plugin
Plugin 'jcf/vim-latex'

" Emmet
Plugin 'mattn/emmet-vim'

" Easy tags
Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-easytags'

" Sublime-style fuzzy search
Plugin 'kien/ctrlp.vim'

" Handlebars support
Plugin 'mustache/vim-mustache-handlebars'
let g:mustache_abbreviations = 1 " turns on abbrevitations

" Rubocop support: run :RuboCop in vim
Plugin 'ngmy/vim-rubocop'
let g:vimrubocop_config = '~/rubocop.yml'

" Ino plugin for Arduino
Plugin 'jplaut/vim-arduino-ino'

" Auto align hashes via highlighting and <Enter>:
Plugin 'junegunn/vim-easy-align'
vmap <Enter> <Plug>(EasyAlign)

" Processing plugin
Plugin 'sophacles/vim-processing'

" Plugin 'scrooloose/syntastic'
" Syntastic is great but I never got around to figuring out how to
" add more system directories, so we get in fights over Hanson modules

Plugin 'scrooloose/nerdcommenter'
" <map>cs for multi-line comments
" <map>ci to toggle regular comments
" <map>cc to add regular comments (will nest)
" add a number or highlight text to comment the next x lines or portion,
" e.g., 5,cs to comment the next 5 lines

Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"

" Optional:
Bundle "honza/vim-snippets"

Plugin 'ervandew/supertab'
" TAB = AUTOCOMPLETE. YAY.
" the SuperTabMappingForward, SuperTabMappingBackward, and
" SuperTabMappingLiteral settings let you change the mappings

Plugin 'tpope/vim-fugitive'
" Git in Vim!
" :Gstatus for Git status
" :Gcommit <-m message> to commit

Plugin 'tpope/vim-surround'
" shortcuts for adding/changing quotes, brackets, and other surroundings

Plugin 'scrooloose/nerdtree'
" easy file/directory navigation!!!
" :NERDTree to open it up
" m to add/delete/copy/rename files and directories
" C to make the dir under the cursor as the top directory
" r to refresh (R to refresh root)

Plugin 'terryma/vim-multiple-cursors'
" be everywhere at once!
" <Ctrl>-N to select subsequent instances of the current word
" (and then use 'i', 'cw', etc. as you like)

" Plugin 'a.vim'
" toggle between header/source files (even if they don't exist yet!)
" :A to toggle
" :AS/:AV to toggle and split the window horizontally/vertically

Plugin 'flazz/vim-colorschemes'
Plugin 'chriskempson/vim-tomorrow-theme'
" some colorschemes

call vundle#end()

" filetypes need to be turned on and comment editing changed
" HERE for things to work properly
filetype plugin indent on
au FileType * setlocal fo-=cro

" search options
set incsearch       " start searching immediately
set nohlsearch      " don't highlight searches (ew)
set ignorecase      " default to case-insensitive
set smartcase       " case sensitive when search includes caps
set matchtime=5     

set textwidth=85

" deletes parameters in next and previous parenthesis respectively
onoremap in( :<C-U>normal! f(vi(<CR>
onoremap il( :<C-U>normal! F)vi(<CR>
onoremap in" :<C-U>normal! f"vi"<CR>

" map so pasting in insert mode is easy
inoremap <Leader>p <C-O>p

" indentation options, because auto-indenting is MAGIC
set smarttab
set autoindent
set smartindent
set cindent
set tabstop=3
set softtabstop=3
set shiftwidth=3
set expandtab
set shiftround
set preserveindent

au FileType,BufNewFile,BufRead javascript,*.m setlocal tabstop=2
au FileType,BufNewFile,BufRead javascript,*.m setlocal softtabstop=2
au FileType,BufNewFile,BufRead javascript,*.m setlocal shiftwidth=2

au FileType,BufNewFile,BufRead md setlocal textwidth=1000

" limits width for c and c++ files
au FileType h,c,cpp highlight Overlength ctermbg=red ctermfg=white guibg=#592929
au Filetype h,c,cpp,js match Overlength /\%86v.\+/

" For 40-HW9 (syntax colours, etc.)
au BufNewFile,BufRead *.ums,*.um set filetype=ums

au BufRead,BufNewFile *.tex set filetype=tex
au BufRead,BufNewFile *.tac,*.tin,*.itin set filetype=cpp

au BufNewFile,BufRead *.hbs set filetype=html
au BufNewFile,BufRead *.handlebars set filetype=html
au BufNewFile,BufRead *.erb set filetype=html

" woohoo SYNTAX COLOURS
syntax on
set showmatch
set background=dark
color codeschool

" some nice HAML folding
set foldmethod=manual

" bye-bye annoying error sounds!
set noerrorbells
set visualbell
set t_vb=

" navigation...
set backspace=indent,eol,start
set whichwrap+=<,>,[,]
set ch=2
set history=100                 " remember stuff
set undolevels=100              " remember more stuff
set number                      " LINE NUMBERS
set ruler                       " show the current location in the command-line
set scrolloff=5                 " keep some context visible
set showmode
set cmdheight=2                 " bigger command-line
" set nomousehide               " uncomment if you're using a touchpad
                                " and it's driving you insane

" file navigation...
set autoread                    " update the file in Vim if it changes outside
set wildmode=longest:full       " (better) autocompletion for file names
set wildmenu                    " in the command-line!
set hidden                      " keep buffers open in the background
set lazyredraw
set noswapfile                  " swap files and backups get annoying
set nobackup                    " ...use version control instead!
set laststatus=2                " command-line statuses in ALL the windows
set switchbuf=useopen           " jump to the requested buffer if it's open
set eol                         " automatically add an EOL in non-binary files

" Allow for easy buffer switching
nnoremap <S-J> <C-W>j
nnoremap <S-K> <C-W>k
nnoremap <S-H> <C-W>h
nnoremap <S-L> <C-W>l
nnoremap <C-c> :2winc +<CR>
nnoremap <C-a> :2winc -<CR>

" encoding...
set encoding=utf-8
set termencoding=utf-8

" mappings and abbreviations
let mapleader = ","
inoremap jj <Esc>           " jj exits insert mode if typed quickly
map <Ctrl>w<down> <Ctrl>wj  " more window nav shortcuts
map <Ctrl>w<up> <Ctrl>wk
inoremap ,, <Tab>           " ,, works as a tab in insert mode if typed quickly

" more bits and pieces
set tags=tags;/
set nomodeline

" Bundle settings
" NERDCommenter
let NERDSpaceDelims=1       " spaces! in comments! YAY!
" NERDTree
let NERDTreeChDirMode=2     " use the top dir in NERDTree as the working dir
let NERDTreeShowHidden=0    " don't show hidden files ('I' toggles this)
" DelimitMate
let delimitMate_expand_cr=1
" Syntastic
" let syntastic_cpp_checkers=['gcc.vim'] 
" let syntastic_scss_checkers=['scss.vim'] 
" let syntastic_haml_checkers=['haml.vim'] 
" let g:syntastic_javascript_checkers=['javascript.vim'] 
" let g:syntastic_ruby_checkers=['rubocop', 'mri']

" quickly open and souce vimrc
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

autocmd Filetype gitcommit setlocal spell textwidth=72
" set spelling and text-width for git commit messages

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE: 
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE: 
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " By default, Cscope script adds cscope.out from Vim's current directory and from
    " $CSCOPE_DB. However, if you start Vim from say ~/proj/src/a/b/c/, while
    " cscope.out is at ~/proj/src/, that cscope.out won't be loaded automatically.

    " For ctags, there is a nice trick: with the command :set tags=tags;/ Vim will
    " look for tags file everywhere starting from the current directory up to the
    " root.

    " This tip provides the same "autoloading" functionality for Cscope
    " source: http://vim.wikia.com/wiki/Autoloading_Cscope_Database
    function! LoadCscope(filename)
       let db = findfile(a:filename, ".;")

       if (!empty(db))
          let path = strpart(db, 0, match(db, "/" . a:filename . "$"))

          set nocscopeverbose " suppress 'duplicate connection' error
          exe "cs add " . db . " " . path
          set cscopeverbose
       endif
    endfunction

    au BufEnter /* call LoadCscope("cscope.out")
    au BufEnter /* call LoadCscope("py_cscope.out")

    " show msg when any other cscope db added
    set cscopeverbose  


    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout 
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout 
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100
endif

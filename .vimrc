" prevents backwards compatibility with vi
set nocompatible

" filetypes woohoo - off for vundle
filetype off

" Vundle setup
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/vundle'

" cppcheck / vim integration
Plugin 'vim-scripts/cpp_cppcheck.vim'

Plugin 'yssl/QFEnter'

let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" tmux / vim integration
Plugin 'christoomey/vim-tmux-navigator'

Plugin 'editorconfig/editorconfig-vim'
" adds support for .editorconfig files

Plugin 'pangloss/vim-javascript'
" Javascript indent plugin

Plugin 'Raimondi/delimitMate'
" auto-close brackets, quotes, etc.

" Latex plugin
" Plugin 'jcf/vim-latex'

" Bindings based on CtrlP
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-CR>', '<C-s>', '<C-x>']
let g:qfenter_keymap.topen = ['<C-t>']

" This is currently broken
" Ale - async linting
" Plugin 'w0rp/ale'
" let g:ale_lint_on_text_changed = 'never'

" Emmet
Plugin 'mattn/emmet-vim'

" Easy tags
Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-easytags'

" Sublime-style fuzzy search
Plugin 'kien/ctrlp.vim'
let g:ctrlp_max_files=0
let g:ctrlp_open_new_file='v' " open new window in vertical split
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files']

" Dispatch background tasks neatly
Plugin 'tpope/vim-dispatch'

" Easily switching between source and header files
Plugin 'vim-scripts/a.vim'

" Handlebars support
Plugin 'mustache/vim-mustache-handlebars'
let g:mustache_abbreviations = 1 " turns on abbrevitations

" Ino plugin for Arduino
Plugin 'jplaut/vim-arduino-ino'

" Auto align hashes via highlighting and <Enter>:
Plugin 'junegunn/vim-easy-align'
vmap <Enter> <Plug>(EasyAlign)

" Processing plugin
Plugin 'sophacles/vim-processing'

Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"

" Optional:
Bundle "honza/vim-snippets"

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
" set nohlsearch      " don't highlight searches (ew)
set ignorecase      " default to case-insensitive
set smartcase       " case sensitive when search includes caps
set matchtime=5     

set textwidth=80

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


highlight Overlength ctermbg=red ctermfg=white guibg=#592929
match Overlength /\%80v.\+/
set colorcolumn=81

au BufRead,BufNewFile *.tex set filetype=tex
au BufNewFile,BufRead *.hbs set filetype=html
au BufNewFile,BufRead *.handlebars set filetype=html
au BufNewFile,BufRead *.erb set filetype=html
au BufNewFile,BufRead *.zsh-theme set filetype=zsh
au BufNewFile,BufRead *.log set filetype=text
au BufNewFile,BufRead *.notes set filetype=md

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
set history=1000                 " remember stuff
set undolevels=1000              " remember more stuff
set number
set relativenumber                      " LINE NUMBERS
highlight clear LineNr
set ruler                       " show the current location in the command-line
set scrolloff=5                 " keep some context visible
set showmode
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

" Unmap <C-j> in vim-latex so it can be used by vim-tmux-navigator to switch panes
imap <C-space> <Plug>IMAP_JumpForward
nmap <C-space> <Plug>IMAP_JumpForward
vmap <C-space> <Plug>IMAP_JumpForward

" Allow for easy window switching
nnoremap <C-c> :2winc +<CR>
nnoremap <C-a> :2winc -<CR>

" Sane splitting
set splitright
set splitbelow

" for searching in visual blocks use 's'
vnoremap s <Esc>/\%V

" encoding...
set encoding=utf-8
set termencoding=utf-8

" Suppress warnings from :make command in copen
set errorformat^=%-G%f:%l:\ warning:%m

" mappings and abbreviations
let mapleader = ","
inoremap jj <Esc>           " jj exits insert mode if typed quickly

" more bits and pieces
set tags=tags;/
set nomodeline

" Bundle settings
" NERDTree
let NERDTreeChDirMode=2     " use the top dir in NERDTree as the working dir
let NERDTreeShowHidden=0    " don't show hidden files ('I' toggles this)
" DelimitMate
let delimitMate_expand_cr=1

" Syntastic
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" 
" " Syntax checkers
" let syntastic_cpp_checkers=['gcc'] 
" let syntastic_scss_checkers=['scss'] 
" let syntastic_haml_checkers=['haml'] 
" let g:syntastic_javascript_checkers=['javascript'] 
" let g:syntastic_python_checkers=['pylint'] 
" let g:syntastic_ruby_checkers=['rubocop', 'mri']
" 
" " Massive mapping to allow ']l' and '[l' to move between Syntastic errors
" nnoremap ]l :try<bar>lnext<bar>catch /^Vim\%((\a\+)\)\=:E\%(553\<bar>42\):/<bar>lfirst<bar>endtry<CR>


" quickly open and souce vimrc
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" set spelling and text-width for git commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0
	 " set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
	 set cscopequickfix=s-,c-,t-

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

    cs reset
    au BufEnter /* call LoadCscope("cscope.out")
    au BufEnter /* call LoadCscope("c_cscope.out")
    au BufEnter /* call LoadCscope("pycscope.out")

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
endif

" Clipper specific setting
nnoremap <C-y> :call system('nc -U ~/.clipper.sock', @0)<CR>

" Disable that annoying "help" binding
map <S-k> <Nop>

" tmux style zoom feature
nnoremap <Leader>z :tabnew %<CR>

" Open all buffers in tabs
nnoremap <Leader>bt :tab sball<CR>

" remove trailing whitespace

fun! TrimWhitespace()
   let l:save = winsaveview()
   %s/\s\+$//e
   w
   call winrestview(l:save)
endfun
nnoremap <Leader>w :call TrimWhitespace()<CR>

" Binding cnext / cprev
nnoremap <Leader>n :cnext<CR>
nnoremap <Leader>p :cprevious<CR>

nnoremap <Leader>cn :cnext<CR>
nnoremap <Leader>cp :cprev<CR>

nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>h :split<CR>

" ipdb debugger
function! Markline(lineNbr)
  call clearmatches()
  call matchadd('Search', '\%'.a:lineNbr.'l')
  call cursor(a:lineNbr,0)
  normal ml
  normal zz
endfunction

" Arista specific settings
if filereadable(glob("~/.vimrc.arista")) 
   source ~/.vimrc.arista
endif

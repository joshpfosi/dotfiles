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
Plugin 'xolox/vim-easytags'

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

Plugin 'scrooloose/syntastic'
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
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set shiftround
set preserveindent

" tab setting
au FileType,BufNewFile,BufRead h,c,cpp,ino,arduino setlocal tabstop=4
au FileType,BufNewFile,BufRead h,c,cpp,ino,arduino setlocal softtabstop=4
au FileType,BufNewFile,BufRead h,c,cpp,ino,arduino setlocal shiftwidth=4

au FileType,BufNewFile,BufRead javascript setlocal tabstop=2
au FileType,BufNewFile,BufRead javascript setlocal softtabstop=2
au FileType,BufNewFile,BufRead javascript setlocal shiftwidth=2

au FileType,BufNewFile,BufRead md,*.tex setlocal textwidth=1000

" limits width for c and c++ files
au FileType h,c,cpp highlight Overlength ctermbg=red ctermfg=white guibg=#592929
au Filetype h,c,cpp,js match Overlength /\%81v.\+/

" For 40-HW9 (syntax colours, etc.)
au BufNewFile,BufRead *.ums,*.um set filetype=ums

" For 170 LaTex homework
au BufNewFile *.tex set filetype=tex
au BufNewFile *.tex TTemplate comp170

au BufNewFile,BufRead *.hbs set filetype=html
au BufNewFile,BufRead *.handlebars set filetype=html
au BufNewFile,BufRead *.erb set filetype=html

au BufNewFile,BufRead *.html set spell

" <map>,w for rapid save and compile
noremap <Leader>w :wa<CR>:!ino build<CR>

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
set tags=tags;/             " some day I'll actually learn how to use tags
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
let syntastic_cpp_checkers=['gcc.vim'] 
let syntastic_scss_checkers=['scss.vim'] 
let syntastic_haml_checkers=['haml.vim'] 
let g:syntastic_javascript_checkers=['javascript.vim'] 
let g:syntastic_ruby_checkers=['rubocop', 'mri']

" quickly open and souce vimrc
nnoremap <leader>ev :split $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

autocmd Filetype gitcommit setlocal spell textwidth=72
" set spelling and text-width for git commit messages

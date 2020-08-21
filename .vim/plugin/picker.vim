"BUGMODE
"start vim with b:bugmode=1 for this to work
"alias bvim="vim --cmd 'let b:bugmode=1' "
"useful while triaging
"eg:a4 bugs -u appumj | bvim \-

"runs a shell command and loads a scratchfile with the output
"eg: R ls -la
command! -nargs=* -complete=shellcmd R enew | setlocal buftype=nofile  noswapfile | 0r !<args>


function! ActivateBugMode()
   setlocal cursorline
   " map Enter and leader enter keys
   nnoremap <buffer> <Enter> :call LinePick()<CR>
   nnoremap <buffer> <leader><Enter> :call WordPick()<CR>
   nnoremap <leader>A :call ToggleComments()<CR>
   nnoremap <leader>H :call BugHist()<CR>
endfunction

function! ActivateLogMode()
   call ActivateBugMode()
   setlocal nocursorline

   " get branch and changenumber info from the first line
   " this is used later while trying to get the correct version of the source
   " file in tracebacks
   let firstline = getline( 1 )
   let matches = matchlist( firstline, '\(\S\+\)@\(\d\+\)' )
   if len( matches ) > 0
      let b:branch = matches[1]
      let b:changenum = matches[2]
   endif
endfunction

if exists('b:bugmode')
   call ActivateBugMode()
endif

nnoremap <leader>bu :call ActivateBugMode()<CR>
nnoremap <leader>lu :call ActivateLogMode()<CR>

" toggle bug comments
function! ToggleComments()
   if b:allComments == 1
      call CbugImpl(0, b:bugnum )
   elseif b:allComments == 0
      call CbugImpl(1, b:bugnum )
   endif
endfunction

command! -nargs=1 Cbug call CbugImpl(0,<args>)
command! -nargs=1 Cbugall call CbugImpl(1,<args>)

nnoremap <leader>su /https\?:\/\/\S\+<CR>
map <leader>o :Cbug 

function! BugHist()
   if exists( 'b:bugnum' )
      call BugHistImpl( b:bugnum )
   else
      echo "couldnt find bugnumber. use BugHistImpl(bugnumber) explicitly"
   endif
endfunction

function! BugHistImpl(bugNbr)
   let histfilename = "hist".string(a:bugNbr)
   let bug = string(a:bugNbr)
   let title = "BUG dashboard for ".string(a:bugNbr)

   call GotoTempWin()
   let bufnum = bufnr( histfilename )
   if bufnum != -1
      execute 'buffer '.bufnum
      return
   endif


   echo "Fetching BUG history for ".a:bugNbr
   execute "R bughist ".bug
   execute "read  !ap job --hitBug=".bug." -u"
   0put =title
   3put ='----------------------------'
   execute "read !bugtesthist ".bug
   set buflisted
   set buftype=nofile
   execute "silent file ".histfilename

   call ActivateBugMode()
   let b:bugnum = a:bugNbr
   call TmuxSetBug()

endfunction


" open bug details
" allComments - if true, display all comments 
" bugNbr - bug id of the bug to be displayed
function! CbugImpl(allComments,bugNbr)
   let cmdline = "a4 bugs ".a:bugNbr." --logre -A"

   if a:allComments == 0
      let bugfilename = "bug".a:bugNbr
   else
      let cmdline = cmdline." --all-comments"
      let bugfilename = "bugall".a:bugNbr
   endif

   "check if it already exists and delete it
   "will create a new one every time
   let bufnum = bufnr( bugfilename )
   if bufnum != -1
      execute 'bdelete '.bufnum
   endif

   call GotoTempWin()

   echo "Fetching BUG ".a:bugNbr
   echo "cmdline is".cmdline
   execute "R ".cmdline
   set buflisted
   set buftype=nofile

   "display the dashboard link for convenience
   let dashboard =  "http://dashboard/#/?bug=".a:bugNbr."&ndays=60" 
   0put =dashboard
   execute "silent file ".bugfilename
   1
   call ActivateBugMode()

   let b:bugnum = a:bugNbr
   let b:allComments = a:allComments
   call TmuxSetBug()
   call GotoPrevWin()
endfunction

" sets a tmux variable @bugnum for the current window
" usefull for access in other panes of the same window
" eg: see usage of BUG in ~/.slackoff/slackoff.zsh
"

function! TmuxSetBug()
   if exists( 'b:bugnum' )
      let g:bugnum = b:bugnum
      silent execute "!tmux setw -q @bugnum " . b:bugnum 
      silent execute 'redraw!'
   endif
endfunction

function! InsertCurrentBug()
  if exists('g:bugnum')
     let @x = g:bugnum
     normal! "xp
  endif
endfunction
imap <leader>ib ~<esc>x:call InsertCurrentBug()<cr>a

" set the bugnum tmux variable every time a 'bug' buffer is opened
au BufEnter bug* :call TmuxSetBug()

let g:lineRegexList = []
let g:wordRegexList = []
function! AddLineRegex( regex, funcName )
   call add( g:lineRegexList, [ a:regex, a:funcName ] )
endfunction

function! AddWordRegex( regex, funcName )
   call add( g:wordRegexList, [ a:regex, a:funcName ] )
endfunction

function! PickImpl( regList, input )
   for i in a:regList
      let regex = i[0]
      let funcName = i[1]
      if exists( "*".funcName )
         let matches = matchlist( a:input, regex )
         if len( matches ) > 0
            let s:Func = function( funcName )
            call s:Func( matches )
            return
         endif
      else
         echom "Function " . funcName . " for regex '" . regex . "' does not exist"
      endif
   endfor
endfunction

function! WordPick()
   call PickImpl( g:wordRegexList, expand("<cword>") )
endfunction

function! LinePick()
   call PickImpl( g:lineRegexList, getline('.') )
endfunction


"add regex and the functions to be called to the appropriate list
"line regex if the entire line has to be matched
"word regex if the current word has to be matched

"regex function definitions
"--------------


function GetLastNPaths(path,num)
   let parts = split( a:path, '/' )
   let l:num = a:num
   if a:num > len( parts )
      let l:num = len( parts )
   endif
   let selected = parts[ -l:num: -1 ] 

   return join( selected , '/' )
endfunction

" Attempt to find the location of the file in /src. This is useful while trying
" to find the perforce version of the file at particular branch and changenumber
" eg: FindSrcFile( '/usr/lib/python2.7/site-packages/EbraBridgeTestLib.py' )
" should return '//src/BridgeTest/berlin-rel/EbraBridgeTestLib.py@1234' if the
" test file branch and changenum has been set by ActivateLogMode.
" A few corner cases like ArosTest/__init__.py are handled horribly for now.

" Algorithm for eg:/usr/lib/python2.7/site-packages/CliTestClient/__init__.py
" look for __init__.py in /src -> find . -name  | wc -l
" If only 1 hit, that is the file
" else, 
" look for CliTestClient/__init__.py and so on
function! FindSrcFile(path)
      if exists('b:branch')
         "attempt to see the exact version of the file
         let fname = a:path
         let matches = matchlist ( fname , '/usr/' )
         if len ( matches ) > 0
            " special cases
            if matchstr( fname, 'ArosTest/__init__.py' )
               let srcFname = '/src/ArosTest/ArosTest/__init__.src.py'
            elseif matchstr( fname, 'CliMode/__init__.py' )
               let srcFname = '/src/CliMode/CliMode/__init__.src.py'
            elseif matchstr( fname, 'CliMode/CliTestMode/__init__.py' )
               let srcFname = '/src/CliMode/CliTestMode/__init__.src.py'
            elseif matchstr( fname, 'Arnet/__init__.py' )
               let srcFname = '/src/Arnet/__init__.src.py'
            else
               let parts = split( fname, '/' ) 
               let partIndex = 1
               let partsMax = len( parts ) - 1
               while partIndex <= partsMax
                  let searchPart = GetLastNPaths( fname, partIndex )
                  let searchcmd = "find /src | grep \'/" . searchPart . "\'"
                  let filecount = systemlist( searchcmd .'| wc -l ' )[0]
                  if filecount == 1
                     let srcFname = systemlist( searchcmd )[0]
                     break
                  endif
                  let partIndex += 1
               endwhile
            endif

            if !exists( 'srcFname' )
               return fname
            endif
         endif "if match /usr

         return srcFname
         " let srcParts = split( srcFname , '/' )
         " let newSrcParts = srcParts[ 0:1 ] + [ b:branch ] + srcParts[ 2:-1 ]
         " return '//' . join( newSrcParts , '/' ) . '@' . b:changenum
      else 
         return a:path
      endif  "if b branch
endfunction!

" Check if nonempty and a temp split window exist .Open that
" else Create a temporary split window at the bottom
" set a window local w:selected variable to look it up later
" also save previous_winnr
fun! IsEmpty()
    if line('$') == 1 && getline(1) == ''
        return 1
    else
        return 0
    endif
endf

nnoremap <silent><leader>ve :call OpenVimrc()<CR>

function! GotoTempWin()
   let tempwinnr = -1
   for i in range(1, winnr('$'))
     let id = getwinvar(i, 'tempwin', -1)
     if id == 1
       let tempwinnr = i
       break
     endif
   endfor
   let g:previous_winnr = winnr()
   if tempwinnr == -1
      if !IsEmpty()
         rightbelow split
      endif
      let w:tempwin = 1
   else
      execute tempwinnr . 'wincmd w'
   endif
endfunction

function! GotoPrevWin()
   if exists( 'g:previous_winnr' )
      execute g:previous_winnr . 'wincmd w'
   endif
endfunction

function! PickFile(matches)
      let fname = a:matches[ 1 ]
      let lineno = a:matches[ 2 ] 

      let srcFname = FindSrcFile( fname )
      if srcFname != fname && exists('b:branch') 
         "this means we have a proper perforce path in srcFname

         "We choose to name the buffer the last part of the filename
         "check if it already exists and delete it
         "will create a new one every time
         let bufname = split( fname, '/' )[-1]
         let bufnum = bufnr( bufname )
         if bufnum != -1
            execute 'bdelete '.bufnum
         endif

         " let cmdline =  "a4 print -q ".srcFname
         let cmdline =  "a4 project print -q -p ".b:branch." -c ".b:changenum." ".srcFname
         call GotoTempWin()
         execute "R ".cmdline
         set buflisted
         set buftype=nofile
         execute "silent file ". bufname
      else
         " we don't have a perforce path. Just the given path
         call GotoTempWin()
         execute "silent view ".fname
      endif

      if fname[-3:-1] == '.py'
         setf python
      endif 

      call Markline( lineno )
      call GotoPrevWin()
endfunction

function PickUrl(matches)
   let url = a:matches[0]
   execute "silent view ".url
   1
   call ActivateLogMode()
endfunction

let g:cbugall_default = 0

function PickBug(matches)
   let bugnum = a:matches[1]
   if g:cbugall_default == 1
      Cbugall bugnum
   else
      Cbug bugnum
   endif
endfunction

"regex definitions
"--------------
call AddLineRegex( 'https\?:\/\/\S\+', 'PickUrl' ) 
call AddWordRegex( '^\(\d\+\)$', 'PickBug' )
call AddLineRegex( '^\(\d\+\).*$', 'PickBug' )
call AddWordRegex( '^BUG\(\d\+\)$', 'PickBug' )
call AddLineRegex( '^BUG\(\d\+\).*$', 'PickBug' )
call AddLineRegex( 'File \"\([^"]\+\)\", line \(\d\+\)', 'PickFile'  )

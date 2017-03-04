" File: lib.vim
" Author: Yegappan Lakshmanan
" Version: 2.0
" Last Modified: August 29, 2001
"
" Vim script containing library functions used by other Vim scripts.
"
" The following routines are defined in this script:
" 1. Function to display a warning message
" 2. Function to highlight command outputs
" 3. Function to highlight a line.
" 4. Locate a Vim window with a particular variable set.  
" 5. Run a command and read the output into a Vim window
" 6. Routine to process a command output line
" 7. Select the next/previous line in a command output window and process it
"

" If you prefer different keys for jumping to the next/previous matches
" in the command window, change the following key assignments
let cmdNextKey='\f'
let cmdPrevKey='\b'

" --------------------- Do not edit after this line ------------------------

function! IsValidFileName(fname)
    " No file name
    if a:fname == ""
        call s:WarnMsg("Filename not supplied")
        return 0
    endif

    if !filereadable(a:fname)
        call s:WarnMsg("File " . a:fname . " doesn't exist")
        return 0
    endif

    return 1
endfunction

function! IsCmdError(cmd_output)
    if !v:shell_error
        return 0
    endif

    let output=substitute(a:cmd_output, "\n", "", "g")
    call s:WarnMsg(output)

    return 1
endfunction

" Mark the current buffer as a temporary buffer
function! MarkScratchBuffer()
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nomodifiable
endfunction

" Display the supplied warning message
function! WarnMsg(msg)
    echohl WarningMsg
    echo a:msg
    echohl None
endfunction

" Syntax color the output from various commands
function! OutputSyntax(plugin)
    "echo "XXX: Outputsyntax=" . a:plugin
    if has("syntax") && exists("*". a:plugin . "OutputSyntax")
        call {a:plugin}OutputSyntax()
    endif
endfunction

function! ProcessOutputBuffer(plugin)
    "echo "XXX processotuput = " . a:plugin
    if exists("*" . a:plugin . "ProcessOutputBuffer")
       call {a:plugin}ProcessOutputBuffer()
    endif
endfunction

" Highlight the line containing the supplied text, assuming only one is
" present in the current buffer, with the search pattern.  Only
" one line can be highlighted at a time using this routine
function! HighlightLine(line_text, plugin)
    "echo "XXX HighlightLine=".a:plugin
    if has("syntax")
        " Clear the previously highlighted line
        call OutputSyntax(a:plugin)
        execute "syntax match Search /^" . a:line_text . ".*$/"
    endif
endfunction

" Get the number of the window with the specified id variable set
function! LocateWindowByID(id)
    " Save the current window number
    let saved_winnr = winnr()

    " Goto the topmost window
    if winnr() != 1
        execute "normal \<C-w>t"
    endif

    " Start from the topmost window 
    let i = 1

    let window_id = "w:" . a:id

    " Go through all the windows
    while 1
        " Check if window variable is set
        if exists(window_id)
            " Jump back to the saved window, if the saved window is not
            " the current window
            if saved_winnr != i
                execute "normal " . saved_winnr . "\<C-w>\<C-w>"
            endif
            return i
        endif

        " Next window
        let i = i + 1

        if winbufnr(i) == -1
            " Last window
            break
        endif

        " Jump to the window
        execute "normal \<C-w>j"

    endwhile

    " Jump back to the saved window, if not already in that window
    if saved_winnr != winnr()
        execute "normal " . saved_winnr . "\<C-w>\<C-w>"
    endif

    " Window with identifier not found
    return -1
endfunction

" Run a command and get the output in a specified buffer in a specified
" window.  Returns -1, if there is no output
function! RunCommand(cmd, bufname)
    let bufToken = split(a:bufname, '\.')
    "echo "XXX: g:plugin" . g:plugin
    let plugin = bufToken[-1]
    let g:plugin = plugin
    "echo "XXX: runcommand=" . plugin

    "Run the command and get the output
    let cmd_output = system(a:cmd)

    " Clear the status line
    echo ""

    " No output from the command
    if cmd_output == ""
        return -1
    endif

    " Check if the destination file window already exists or not 
    let CmdFileWindow = LocateWindowByID("cmd_file_window")

    " If the destination file window doesn't exists and the current window
    " is not the output window then mark the current window as the
    " destination file window
    if (CmdFileWindow == -1) && (!exists("w:cmd_output_window"))
        let w:cmd_file_window = 1
    endif

    " Locate the window to use for the output
    let CmdOutputWindow = LocateWindowByID("cmd_output_window")

    if CmdOutputWindow == -1
        " Open a new buffer
        execute "new " . a:bufname
        let w:cmd_output_window = 1
    else
        execute "normal " . CmdOutputWindow . "\<C-w>\<C-w>"

        " Save the old name of the command output buffer
        let oldbufname = expand("%")
        let newbufname = a:bufname

        " Change the window name
        execute "file " . newbufname

        " Remove the old buffer, if it is not used
        if (oldbufname != newbufname)
            "execute "bdelete " . oldbufname
        endif
    endif

    " No need for a swapfile for the command output buffer
    set noswapfile

    " Mark the buffer as not readonly
    set noreadonly

    " Goto the first line in the file
    go

    " Delete the contents of the file to the black-hole register
    %d _

    " Copy the command output to the buffer
    0put =cmd_output

    " PreProcess the buffer
    call ProcessOutputBuffer(plugin)

    " Apply syntax coloring
    call OutputSyntax(plugin)

    " Mark the output buffer as not modified
    set nomodified

    " Mark the buffer as readonly
    set readonly

    " Jump to the first line in the buffer
    '[

    " Reset the last cmd line number tracker
    let w:CmdWindowLastLineNumber = 0

    " Setup keys to jump to the next/previous matches in the cmd output
    call CmdMapKeys(plugin)

    return 0
endfunction

" Process one of the command output lines
function! ProcessCmdOutputLine(plugin)
    "echo "XXX process line = " . a:plugin
    " Get the filename
    let line_text = getline('.')

    " Handle empty line
    if line_text == ""
        call WarnMsg("Empty line")
        return -1
    endif

    let ret = {a:plugin}ProcessCmdOutputLine( line_text )
    if ret == []
       call WarnMsg("No valid file found")
       return -1
    endif

    let filename = ret[0]
    let linenumber = ret[1]

    if filename == "" || linenumber == ""
        call WarnMsg("Invalid filename or line number")
        return -1
    endif

    " Check whether the file exists
    if !filereadable(filename)
        call WarnMsg("Unable to open " . filename)
        return -1
    endif

    let w:CmdWindowLastLineNumber = line(".")

    " Highlight the line
    let efilename = escape(filename, '/.')
    call HighlightLine(efilename . ":" . linenumber . ":", a:plugin)

    " Expand the file name to full pathname.  This is needed, because
    " bufwinnr() will locate the correct buffer containing this file
    " only if the filename is a full pathname
    let fullfilename = fnamemodify(filename, ":p")

    " If the file is already opened in one of the windows, use that
    " window
    let DestWin = bufwinnr(fullfilename)
    if DestWin != -1
        " Goto that window
        execute "normal " . DestWin . "\<C-w>\<C-w>"

        " Go to the particular line
        execute "normal " . linenumber . "gg"

        " Move the line to the middle of the window
        normal z.

        " Clear the output from calling this function
        let v:statusmsg=""

        return 0
    endif

    " Add + to the linenumber, so that it can be used with :e
    if (strlen(linenumber))
        let linenumber = "+" . linenumber
    endif

    " Get the window number to use
    let DestWin = LocateWindowByID("cmd_file_window")

    " If the destination window is the same window as the output window, 
    " then open a new window.  Mark the current window as not the
    " output window
    if winnr() == DestWin
        unlet w:cmd_file_window
        let DestWin = -1
    endif

    " If the destination window does not exist or it is the same window
    " as the output window, then open a new window
    if DestWin == -1
        " Open a new window and mark it as the file window
        " Always open the new window below the output window
        let oldSplitBelow = &splitbelow
        set splitbelow
        new
        let &splitbelow = oldSplitBelow
        let w:cmd_file_window = 1
    else
        " Goto the already existing file window
        execute "normal " . DestWin . "\<C-w>\<C-w>"
    endif

    " Load the file and goto the line
    execute "e " . linenumber . " " . filename

    " Move the line to the middle of the window
    normal z.

    " Clear the output from calling this function
    echo ""

    return 0
endfunction

" Process the next/previous line in the command output window
" dir == 0, previous line
" dir == 1, next line
function! ProcessNextLine(plugin, dir)
    "echo "XXX process nextline = " . a:plugin
    let saved_winnr = winnr()

    " Locate the command output window
    let CmdOutputWindow = LocateWindowByID("cmd_output_window")

    if CmdOutputWindow == -1
        call WarnMsg("Missing command output window")
        return
    endif

    " Jump to the command window
    if winnr() != CmdOutputWindow
        execute "normal " . CmdOutputWindow . "\<C-w>\<C-w>"
    endif

    " Go to the next line in the command output.  If this is the first
    " time then default to the cursor line
    if exists("w:CmdWindowLastLineNumber")
        if a:dir == 0
            let nextLineNumber = w:CmdWindowLastLineNumber - 1
        else
            let nextLineNumber = w:CmdWindowLastLineNumber + 1
        endif
    else
        let nextLineNumber = line(".")
    endif

    if getline(nextLineNumber) == ""
        call WarnMsg("No more entries")
        execute "normal " . saved_winnr . "\<C-w>\<C-w>"
        return
    endif

    let w:CmdWindowLastLineNumber = nextLineNumber

    " Go to the particular line
    execute "normal " . w:CmdWindowLastLineNumber . "gg"

    " Jump to the next line
    if ProcessCmdOutputLine(a:plugin) == -1
        " If failed to jump, restore the line number and jump back
        " to the source window
        if a:dir == 0
            let w:CmdWindowLastLineNumber = w:CmdWindowLastLineNumber + 1
        else
            let w:CmdWindowLastLineNumber = w:CmdWindowLastLineNumber - 1
        endif
        execute "normal " . saved_winnr . "\<C-w>\<C-w>"
    endif
endfunction

function! CmdMapSelectKeys(plugin)
    "echo "XXX cmdmap bufname=" . a:plugin
    " Map the <CR> key to jump to the line in a specific file
    execute 'nnoremap <CR> :call ProcessCmdOutputLine("' . a:plugin . '")<CR>'

    " Map the leftmouse doubleclick to jump to the line in a specific file
    execute 'nnoremap <2-LeftMouse> :call ProcessCmdOutputLine("' . a:plugin . '")<CR>'
endfunction

function! CmdUnmapSelectKeys(plugin)
    " Unmap the <CR> key
    if maparg("<CR>", "n") != "" 
        nunmap <CR>
    endif

    " Unmap the leftmouse doubleclick
    if maparg("<2-LeftMouse>", "n") != ""
        nunmap <2-LeftMouse>
    endif
endfunction

function! CmdMapKeys(plugin)
    " Map key to jump to the next match
    execute 'nnoremap ' . g:cmdNextKey . ' :call ProcessNextLine("' . a:plugin. '", 1)<CR>'
    " Map key to jump to the previous match
    execute 'nnoremap ' . g:cmdPrevKey . ' :call ProcessNextLine("' . a:plugin. '", 0)<CR>'
endfunction

function! CmdUnmapKeys(plugin)
    if maparg(g:cmdNextKey, "n") != ""
        execute "nunmap " . g:cmdNextKey
    endif

    if maparg(g:cmdPrevKey, "n") != ""
        execute "nunmap " . g:cmdPrevKey
    endif
    execute "bdelete " . bufname("")
endfunction

augroup CmdOutputWindow
    " Remove all previously defined autocommands for this group
    autocmd!
    let plugin=""
    if bufname("") != ""
       let bufToken = split(bufname(""), '\.')
       let plugin = bufToken[-1]
    endif

    autocmd BufEnter _VPLUGIN__.* call CmdMapSelectKeys(plugin)
    autocmd BufLeave _VPLUGIN__.* call CmdUnmapSelectKeys(plugin)
    autocmd BufUnload _VPLUGIN__.* call CmdUnmapKeys(plugin)
augroup end

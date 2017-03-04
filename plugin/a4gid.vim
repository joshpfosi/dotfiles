" File: a4gid.vim
" Author: Senthil Krishnamurthy
" Version: 1.0
" Last Modified: March 22, 2012
" 
" Overview
" --------
" Vim script to lookup a keyword using a4 gid.
"
" You can use the command:
"       :AGid [<id>]
" to lookup <id> using a4 gid. If <id> is not given the keyword under cursor
" is looked up using a4 gid.
"
" You can also pass any a4 gid option to AGid:
"       :AGid -t 'p c C t' -p '' -t '' -r '' [<id>]
" To filter the gid output by file type or package or regex use,
"       :AGidVerbose 
"
" The output from gid will be displayed in a Vim window.  You can select
" a line from the window using either the <Enter> key or by double
" clicking using mouse.  You can jump to the next match using \f
" and to the previous match using \b.
"
" Results are grouped by package by using vim 'folding'.
"
" Hit <Enter> on a package name to unfold.
" Hit <Space> on a fold to unfold.
" zc will close the fold
" zM will close all the open folds
"
" Map keys to invoke a4 gid on a word under cursor.
"
" You can change these key bindings to whatever you like.
"
"nnoremap <F10> :call AGidOnWord()<CR>
"
" Configuration
" -------------
" By changing the following variables you can configure the behavior of this
" plugin. Set the following variables in your .vimrc file using the 'let'
" command.
"
" The 'AGid_Hi_Fold' variable controls the color of the vim folds. You
" can change this using the let command:
"        :let AGid_Hi_Fold = 'cterm=bold ctermbg=21 ctermfg=231'
"
" The 'AGid_Shell_Quote_Char' sets the quote character for the args
" passed to a4 gid. You can change this using the let command:
"        :let AGid_Shell_Quote_Char = "'"
"
" The 'AGid_Default_Options' controls the default options passed to the
" a4 gid command. You can set this using the let command:
"        :let AGid_Default_Options = "-D -t ''"
"

" Highlight color for vim folds
if !exists("AGid_Hi_Fold")
    let AGid_Hi_Fold = "cterm=bold ctermbg=21 ctermfg=231"
endif

" Highlight color for vim fold columns
if !exists("AGid_Hi_FoldColumn")
    let AGid_Hi_FoldColumn = "cterm=bold ctermbg=21 ctermfg=231"
endif

" Character to use to quote patterns and filenames before passing to grep.
if !exists("AGid_Shell_Quote_Char")
    let AGid_Shell_Quote_Char = "'"
endif

" Default a4gid options
if !exists("AGid_Default_Options")
    let AGid_Default_Options = "-t '' -p '' -r ''"
endif

" --------------------- Do not edit after this line ------------------------
function! A4GIDProcessOutputBuffer()
    "echo "XXX a4gid process buffer"
    go
    let lstart = search('^\*\*\* .*:$', 'W')
    let firstFold = 1
    while lstart
        let lstart = lstart + 1
        call cursor(lstart, 1)
        let lend = search('^\*\*\* .*:$', 'Wn')
        if lend == 0
           if firstFold
              break
           endif
           execute ".,$fo"
        else
           execute ".," . (lend - 1) . "fo"
           let firstFold = 0
        endif
        let lstart = lend
    endwhile
endfunction

" Syntax color the output from various commands
function! A4GIDOutputSyntax()
    "echo "XXX a4gid syntax"
    syntax clear
    "set filetype=diff
    syntax match OutputFile "^//.*#"me=e-1
    highlight link OutputFile DiffLine
    execute 'highlight Folded ' . g:AGid_Hi_Fold
    execute 'highlight FoldColumn ' . g:AGid_Hi_FoldColumn
endfunction

function! A4GIDProcessCmdOutputLine(line_text)
    if matchstr(a:line_text, '^\*\*\* .*:$') != ""
        execute '.+1'
        foldopen
        return []
    endif

    " Extract the filename
    let filename = matchstr(a:line_text, '[^:]\+')

    " Extract the line number
    let line = matchstr(a:line_text, ':.*')
    let linenumber = matchstr(line, '\d\+')
    return [filename, linenumber]
endfunction

function! RunA4Gid(...)
    if a:0 > 0 && (a:1 == "-?" || a:1 == "-h")
        echo 'Usage: AGid [<a4_gid_options>] [<search_pattern>]'
        return
    endif

    let gid_opt = ""
    let pattern = (a:0 == 0) ? expand("<cword>") : ""

    let argcnt = 1
    let argval = 0
    while argcnt <= a:0
        if a:{argcnt} =~ '^-[tpr]'
            let gid_opt = gid_opt . " " . a:{argcnt}
            let argval = 1
        elseif argval == 1
            let gid_opt = gid_opt . " " . g:AGid_Shell_Quote_Char . a:{argcnt} .
                     \ g:AGid_Shell_Quote_Char
            let argval = 0
        elseif a:{argcnt} == '-D'
            let gid_opt = gid_opt . "-D"
        elseif pattern == ""
            let pattern = g:AGid_Shell_Quote_Char . a:{argcnt} . 
                            \ g:AGid_Shell_Quote_Char
        else
            echo 'Search one pattern at a time'
            return
        endif
        let argcnt= argcnt + 1
    endwhile
    
    if gid_opt == ""
        let gid_opt = g:AGid_Default_Options
    endif

    if pattern == ""
        let pattern = expand("<cword>")
    endif
    echo "\n"

    let cmd = "a4 gid " . gid_opt
    let cmd = cmd . " " . pattern
    echo cmd

    let bufname = "_VPLUGIN__." . pattern . ".A4GID"
    let retval = RunCommand(cmd, bufname)
    if retval == -1
        call WarnMsg("Identifier " . pattern . " not found")
        return
    endif

endfunction

function! RunA4GidVerbose(...)

    let pattern = ""
    let gid_types = ""
    let gid_pkgs = ""
    let gid_regex = ""

    let pattern = input("Search for pattern: ", expand("<cword>"))
    if pattern == ""
        echo "Search pattern not given"
        return
    endif
    "let pattern = g:AGid_Shell_Quote_Char . pattern . 
                        "\ g:AGid_Shell_Quote_Char

    let gid_types = input("Search for types: ", "p c t C")
    let gid_pkgs = input("Search in packages: ", "*")
    if gid_pkgs == "*"
        let gid_pkgs = ""
    endif
    let gid_regex = input("Filter matches by regex: ", "*")
    if gid_regex == "*"
        let gid_regex = ""
    endif

    let gid_args = []
    if gid_types != ""
        let gid_args += ['-t', gid_types]
    endif
    if gid_pkgs != ""
        let gid_args += ['-p', gid_pkgs]
    endif
    if gid_regex != ""
        let gid_args += ['-r', gid_regex]
    endif

    let gid_args += [pattern]

    echo gid_args
    echo "\n"

    let r = call("RunA4Gid", gid_args)
endfunction

function! AGidOnWord()
    let id = expand("<cword>")
    call RunA4Gid(id)
endfunction

command! -nargs=* -complete=tag AGid call RunA4Gid(<f-args>)
command! -nargs=* -complete=tag AGidVerbose call RunA4GidVerbose(<f-args>)

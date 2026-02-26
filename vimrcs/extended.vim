"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colorscheme related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:base16_customize() abort
    call Tinted_Hi("Search",        g:tinted_gui0A, g:tinted_gui01, g:tinted_cterm0A, g:tinted_cterm01,  "reverse", "")
    call Tinted_Hi("MatchParen",    g:tinted_gui0B, g:tinted_gui01, g:tinted_cterm0B, g:tinted_cterm01,  "bold", "")
    call Tinted_Hi("Constant",      g:tinted_gui0B, "", g:tinted_cterm0B, "", "", "")
    call Tinted_Hi("Deprecated",   "", "", "", "", "", "")
    call Tinted_Hi("Comment",       g:tinted_gui04, "", g:tinted_cterm04, "",  "italic", "")
    call Tinted_Hi("VertSplit",     g:tinted_gui0A, g:tinted_gui01, g:tinted_cterm0A, g:tinted_cterm01,  "", "")
endfunction

function! s:handle_focus_gained() abort
  let l:theme_script_path = expand("~/.local/share/tinted-theming/tinty/artifacts/tinted-vim-colors-file.vim")
  if filereadable(l:theme_script_path)
    execute 'source ' . l:theme_script_path
    call s:base16_customize()
  endif
endfunction

augroup colorscheme_customization
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
  autocmd FocusGained * call s:handle_focus_gained()
augroup END

let s:theme_script_path = expand("~/.local/share/tinted-theming/tinty/artifacts/tinted-vim-colors-file.vim")
if filereadable(s:theme_script_path)
  " Enable true color support for modern terminals
  if has('termguicolors')
    set termguicolors
  endif
  let g:tinted_colorspace = 256
  execute 'source ' . s:theme_script_path
  call s:base16_customize()
endif

" My columns
highlight ColorColumn guibg=#072632
set colorcolumn=21,49,89


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" :set guioptions-=b
" Enable horizontal scrollbar with nowrap
nnoremap <silent><expr> <f2> ':set wrap! go'.'-+'[&wrap]."=b\r"
" Side scroll bindings
map <M-l> zl
map <M-L> zL
map <M-h> zh
map <M-H> zH

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fast editing and reloading of vimrc configs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>e :e! ~/.vim/vimrcs/vimrc<cr>

augroup vimrc_reload
  autocmd!
  autocmd BufWritePost vimrc source ~/.vim/vimrcs/vimrc
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cno $q <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
"cnoremap <C-A>        <Home>
"cnoremap <C-E>        <End>
"cnoremap <C-K>        <C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Map ½ to something useful
map ½ $
cmap ½ $
imap ½ $


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! DeleteTillSlash() abort
    let l:cmd = getcmdline()

    if has("win32")
        let l:cmd_edited = substitute(l:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let l:cmd_edited = substitute(l:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if l:cmd == l:cmd_edited
        if has("win32")
            let l:cmd_edited = substitute(l:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let l:cmd_edited = substitute(l:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return l:cmd_edited
endfunction

function! CurrentFileDir(cmd) abort
    return a:cmd . " " . expand("%:p:h") . "/"
endfunction


"--------------------------------------------------------------------------------
" Clean up files - remove trailing white space, convert tabs to spaces, convert to UNIX newlines
function! CleanUpThis() abort
    exe "normal mz"
    setlocal ff=unix
    silent! %s/\r//g
    if &filetype != "make"
        silent! %s/\t/    /g
    endif
    silent! %s/\s\+$//ge
    exe "normal `z"
endfunction

augroup file_cleanup
    autocmd!
    autocmd BufWrite * call CleanUpThis()
augroup END

" Filetype-specific settings
augroup filetype_settings
    autocmd!
    autocmd FileType make setlocal noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup END

augroup filetypedetectOverride
  autocmd!
  autocmd BufNewFile,BufRead *.v,*.vh,*.vp,*.sv,*.svi,*.svh,*.svp,*.sva setfiletype verilog_systemverilog
augroup END

"--------------------------------------------------------------------------------
" Set titlebar to something useful
set titlelen=200
function! SetWindowName() abort
    let l:filename        = expand("%:t")
    let l:filepath        = expand("%:p")
    let l:mypwd           = expand("%:{getcwd()}")
    let l:modified        = "%M"
    " TODO: Fix this substitution
    let l:viewname        = substitute(l:filepath, "\(mywcps\/\S*\)\/\.\*", "\1", 0)
    let l:viewname        = substitute(l:viewname, "\.\*\/", "", 0)
    if l:viewname == l:filename
        let &titlestring  = l:modified . v:servername . " - " . l:filepath
    else
        let &titlestring  = l:modified . v:servername . " - <" . l:viewname . "> - " . l:filepath
    endif
endfunction

augroup window_title
    autocmd!
    autocmd BufEnter * call SetWindowName()
augroup END

"--------------------------------------------------------------------------------
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView() abort
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView() abort
    let l:buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, l:buf)
        let l:v = winsaveview()
        let l:atStartOfFile = l:v.lnum == 1 && l:v.col == 0
        if l:atStartOfFile && !&diff
            call winrestview(w:SavedBufView[l:buf])
        endif
        unlet w:SavedBufView[l:buf]
    endif
endfunction

" When switching buffers, preserve window view.
augroup preserve_window_view
    autocmd!
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
augroup END

"--------------------------------------------------------------------------------
" Git macros
function! GitDiff() abort
    exe '!git diff % 2>&1'
endfunction
map <F5> :call GitDiff()<CR>

"--------------------------------------------------------------------------------
" Add exec perms to current file
nnoremap <silent> <F7> :!chmod +x %<CR>
cnoremap <silent> <F7> <Esc>:!chmod +x %<CR>
inoremap <silent> <F7> <Esc>:!chmod +x %<CR>a

"--------------------------------------------------------------------------------
function! s:FindWindow(bufName, doDebug) abort
  " Try to find an existing window that contains our buffer.
  let l:bufNum = bufnr(a:bufName)
  if l:bufNum != -1
    let l:winNum = bufwinnr(l:bufNum)
  else
    let l:winNum = -1
  endif

  return l:winNum
endfunction
"--------------------------------------------------------------------------------

" Session management
nmap <F10> <ESC>:call GetSessionName()<CR>
nmap <F11> <ESC>:call LoadSession()<CR>
nmap <F12> <ESC>:call SaveSession()<CR>

" Don't store any options in sessions
set sessionoptions=blank,buffers,curdir,tabpages,winpos,folds

" Session state variables
let s:sessionloaded = 0
let s:sessionName = ""

function! LoadSession() abort
    echo "Loading Session..."
    if s:sessionName == ""
        echo "No session name set"
        call GetSessionName()
    endif

    if filereadable(s:sessionName)
        execute "source " . s:sessionName
        let s:sessionloaded = 1
        echo "Loaded session:" . s:sessionName
    endif
endfunction

function! SaveSession() abort
    echo "Saving Session..."
    if s:sessionName == ""
        echo "No session name set"
        call GetSessionName()
    endif

    execute "mksession! " . s:sessionName
    echo "Saving session:" . s:sessionName
endfunction

function! GetSessionName() abort
    let l:curline = getline('.')
    call inputsave()
    let s:sessionName = input('Enter Session Name: ')
    call inputrestore()
    let s:sessionName = $HOME . "/.vim/temp_dirs/sessions/" . s:sessionName
    echo "Session is :" . s:sessionName
endfunction

function! SaveSessionOnClose() abort
    if s:sessionName == ""
        let s:sessionName = $HOME . "/.vim/temp_dirs/sessions/lastsession"
    endif
    call SaveSession()
endfunction

function! LoadSessionServerName() abort
    if v:servername != "" && v:servername != "GVIM"
        if v:servername =~ "sock"
            let l:myServerName = fnamemodify(v:servername, ":t:r")
        else
            let l:myServerName = v:servername
        endif
        let s:sessionName = tolower($HOME . "/.vim/temp_dirs/sessions/" . l:myServerName)
        if filereadable(s:sessionName)
            call LoadSession()
        endif
    endif
endfunction

augroup session_management
    autocmd!
    autocmd VimLeave * call SaveSessionOnClose()
    autocmd VimEnter * nested call LoadSessionServerName()
augroup END

"--------------------------------------------------------------------------------
" Verilog stuff

let @z="_v48|c.lyeE50i pBd49|i(Ai)j"

let g:moduleName = "dummy_inst"
noremap <F9> :call FormatToInstanceLine()<CR>
function! FormatToInstanceLine() abort
    " Has issues when wrap is enabled - temporarily disable if it's on
    let l:mywrap = &wrap
    setlocal nowrap
    let l:winview = winsaveview()
    let instCurLine=getline('.')
    normal j
    let instNextLine=getline('.')
    normal k

    "--------------------------------------------------------------------------------
    "--------------------------------------------------------------------------------
    " Pure comment lines
    if instCurLine =~ "^ */"
        "----- Comment line - just ensure indentation
        normal _d0i        

    elseif instCurLine == ""
        "----- Skip blank lines

    elseif instCurLine =~ "^ *`"
        "----- Preprocessor directive (`ifdef, `ifndef, `else, `endif, etc.) - preserve content, indentation handled by ==

    elseif instCurLine =~ "^ *module"
        "----- Store module name
        let g:moduleName = split(instCurLine)[1]
        " Remove any paranetheses (handle moving these below)
        let g:moduleName = substitute(g:moduleName,"#(\\|(","","")
        call setline('.', "    " . g:moduleName)
        if instNextLine =~ "^ *("
            call append(line('.'), "    " . "u_" . g:moduleName)
        endif
        if instCurLine =~ "#( *$"
            "----- Try to clean up parentheses on wrong lines
            call append(line('.'), "    #(")
        elseif instCurLine =~ "( *$"
            "----- Non-parametric module with paren on same line - insert instance name then "("
            call append(line('.'),     "    " . "u_" . g:moduleName)
            call append(line('.') + 1, "    (")
            let g:moduleName = "dummy_inst"
        endif

    elseif !(instCurLine =~ ",") && !(instCurLine =~ "\\.") && (instCurLine =~ "^ *[a-zA-Z0-9_]\\+ *$")
        "----- If it's a bare word with no "." or ",", simple format assuming it's an already formatted  module name/instance
        normal _d0i    

    elseif instCurLine =~ "^ *#( *$"
        "----- Just indent stand-alone "#("
        call setline('.', substitute(instCurLine,"^ *","    ",""))

    elseif instCurLine =~ "^ *#("
        "----- Separate "#(" from rest of line
        call setline('.', substitute(instCurLine,"^ *#(","",""))
        normal k
        call append(line('.'), "    #(")

    elseif instCurLine =~ "^ *( *$"
        "----- Just indent stand-alone "("
        call setline('.', substitute(instCurLine,"^ *","    ",""))

    elseif (instCurLine =~ "^ *(") && !(instCurLine =~ '^ *(\*.*\*)')
        "----- Separate "(" from rest of line
        call setline('.', substitute(instCurLine,"^ *(","",""))
        normal k
        call append(line('.'), "    (")

    elseif instCurLine =~ "^ *);"
        "----- Just indent stand-alone ");"
        call setline('.', substitute(instCurLine,"^ *","    ",""))

    elseif instCurLine =~ "); *$"
        "----- Separate "); from rest of line
        call setline('.', substitute(instCurLine,");","",""))
        call append(line('.'), "    );")
        call FormatToInstanceLine()

    elseif instCurLine =~ "^ *)( *$"
        "----- Split ")(" - parameter list close followed immediately by port list open
        "----- Insert instance name between ")" and "("
        call setline('.', "    )")
        call append(line('.'),     "    " . "u_" . g:moduleName)
        call append(line('.') + 1, "    (")
        let g:moduleName = "dummy_inst"

    elseif instCurLine =~ "^ *)"
        "----- Check if followed by synthesis/preprocessor block ending in standalone ";"
        "----- E.g.  )  /  `ifdef SYN / /* synthesis ... */ / `endif / ;
        let l:scan = line('.') + 1
        let l:semi_lnum = -1
        while l:scan <= line('$')
            let l:scanline = getline(l:scan)
            if l:scanline =~ "^ *; *$"
                let l:semi_lnum = l:scan
                break
            elseif l:scanline =~ "^ *$" || l:scanline =~ "^ *`" || l:scanline =~ "^ */"
                let l:scan += 1
            else
                break
            endif
        endwhile

        if l:semi_lnum > 0
            "----- Merge: delete intervening lines and replace ")" with ");"
            let l:cur_lnum = line('.')
            exe (l:cur_lnum + 1) . "," . l:semi_lnum . "d"
            call setline(l:cur_lnum, "    );")
        else
            "----- Need to check two lines ahead
            normal jj
            let instNextNextLine=getline('.')
            normal kk

            if instNextNextLine =~ "^ *( *$"
                "----- Just format
                call setline('.', substitute(instCurLine,"^ *","    ",""))
            else
                "----- Write module instance name below parameter ")"
                call setline('.', substitute(instCurLine,"^ *","    ",""))
                call append(line('.'), "    " . "u_" . g:moduleName)
                " Clear after use as instance
                let g:moduleName = "dummy_inst"
            endif
        endif

    elseif (instCurLine =~ ") *$") && !(instNextLine =~ "^ *)") && !(instCurLine =~ "(")
        "----- Separate ") from rest of line
        call setline('.', substitute(instCurLine,")","",""))
        call append(line('.'), "    )")
        call FormatToInstanceLine()

    elseif instNextLine =~ "^ *#(" || (instNextLine =~ "^ *("  && !(instNextLine =~ '^ *(\*.*\*)'))
        "----- This should be the case were there is a bare word module or instance name
        "----- above an open parentheses. - Do nothing

    else
        "--------------------------------------------------------------------------------
        "--------------------------------------------------------------------------------
        "----- Paramters and ports

        "----- A few items are different for parameters
        if instCurLine=~"^ *parameter"
            "----- Find parameter name as token before "="; fall back to last token if no "=" (e.g. no default value)
            let l:param_tokens = split(instCurLine)
            let l:eq_idx = index(l:param_tokens, "=")
            if l:eq_idx > 0
                let nameIndex = string(l:eq_idx - 1)
            else
                let nameIndex = "-1"
            endif
        else
            let nameIndex = "-1"
        endif

        "--------------------------------------------------------------------------------
        "----- Capture endchar
        let endChar = ""
        if  instCurLine =~ ","
            let endChar = ","
        endif

        "--------------------------------------------------------------------------------
        "----- Remove any synthesis directives. E.G. (* io_buffer_type = "obuf" *)
        "----- Just remove (\*.*\*)
        if instCurLine =~ '^ *(\*.*\*)'
            let instCurLine = substitute(instCurLine,'(\*.*\*)', "", "")
        endif

        "----- Normalize: remove spaces before closing parentheses (handles re-formatting when signame has trailing space)
        let instCurLine = substitute(instCurLine, '\s\+)', ')', 'g')

        "--------------------------------------------------------------------------------
        "----- Capture sginal name and comments
        let commentText = ""
        let name        = ""
        if instCurLine =~ "//"
            let curlineSplit = split(instCurLine, "//")
            let commentText = curlineSplit[-1]
            " If we are re-formatting and the open parenthesis directly follow the port name, add a space
            let curlineSplit[0] = substitute(curlineSplit[0],"("," (","")
            let sigName = split(curlineSplit[0])[nameIndex]
        elseif  instCurLine =~ "/\\*"
            let curlineSplit = split(instCurLine, "/\\*")
            let commentText = curlineSplit[-1]
            " If we are re-formatting and the open parenthesis directly follow the port name, add a space
            let curlineSplit[0] = substitute(curlineSplit[0],"("," (","")
            let sigName = split(curlineSplit[0])[nameIndex]
        else
        "-----   " No comment
            " If we are re-formatting and the open parenthesis directly follow the port name, add a space
            let instCurLine = substitute(instCurLine,"("," (","")
            let sigName = split(instCurLine)[nameIndex]
        endif

        "----- Remove any residual commas (port names mainly)
        let sigName = substitute(sigName,",","","")
        "----- Remove any residual parentheses (for re-formatting)
        let sigName = substitute(sigName,"(","","")
        let sigName = substitute(sigName,")","","")

        "----- This is the case of a reformat with bus delimiters "{}"
        if (instCurLine =~ "{") && !(instCurLine =~"^ *parameter")
            let sigName = matchstr(instCurLine, '(\zs[^)]*\ze)')
            let sigName = substitute(sigName, '^\s\+\|\s\+$', '', 'g')
        endif

        "----- Capture portname
        if instCurLine =~ "^ *\\."
            "----- If the line starts with ".", assume it's already translated and extract the portname
            " If we are re-formatting and the open parenthesis directly follow the port name, add a space
            let instCurLine = substitute(instCurLine,"("," (","")
            let portName = split(instCurLine)[0]
            let portName = substitute(portName,"\\.","","")
        else
            let portName = sigName
        endif

        "----- Remove array delimeters from portname
        let portName = substitute(portName,"\\[.*\\]","","")


        "--------------------------------------------------------------------------------
        " Now we need to assemble the portmap with appropiate spacings

        " 1) Portname
        let newLine = "        ." . portName
        let newLineLen = strlen(newLine)

        " 2) Signame
        if newLineLen < 48
            " Short
            let paddingNum  = 48  - newLineLen
            let padding     = repeat(" ", paddingNum)
        else
            " Too Long
            let padding     = " "
        endif
        let newLine = newLine . padding . "(" . sigName . ")" . endChar
        let newLineLen = strlen(newLine)

        " 3) Comment
        if !(commentText == "")
            if newLineLen < 88
                " Short
                let paddingNum  = 88  - newLineLen
                let padding     = repeat(" ", paddingNum)
            else
                " Too Long
                let padding     = " "
            endif
            let newLine = newLine . padding . "//" . commentText
        endif

        "----- Write out line
        call setline('.', newLine)

    endif

    call winrestview(l:winview)
    "----- Restore previous wrap setting
    if l:mywrap
        set wrap
    endif
    "----- Fix indentation
    "call indent('.')
    normal ==
endfunction

noremap <F8> :call FormatToInstance()<CR>
function! FormatToInstance() abort
    let g:moduleName = "dummy_inst"
    let l:winview = winsaveview()
    let l:curline = ""
    while !(l:curline =~ "^ *);")
        let l:curline = getline('.')
        call FormatToInstanceLine()
        if getline('.') =~ "^ *);"
            break
        endif
        normal j
    endwhile
    call winrestview(l:winview)
endfunction

" TODO: noremap <F8> :call FormatPortLine()<CR>
function! FormatPortLine() abort
    let l:winview = winsaveview()
    let l:curline = getline('.')
    if l:curline =~ "^ *input" || l:curline =~ "^ *output" || l:curline =~ "^ *inout"
        "normal $
        "let endchar=getline('.')[col('.')-1]
        "if endchar == "," || endchar == ";"
        if curline =~ "," || curline =~ ";"
            if curline=~"["
                normal f,x_10i ld5|W13i ld12|W18i ld17|W50i ld49|ea,
            else
                normal f,x_10i ld5|W13i ld12|W50i ld49|ea,
            endif
        else
            if curline=~"["
                normal _10i ld5|W13i ld12|W18i ld17|W50i ld49|
            else
                normal _10i ld5|W13i ld12|W50i ld49|A,
            endif
        endif
    elseif curline=~"^ *parameter"
        normal $
        let endchar=getline('.')[col('.')-1]
        if endchar == "," || endchar == ";"
            normal x_10i ld5|W50i ld49|W81i ld81|ea,
        else
            normal  _10i ld5|W50i ld49|W81i ld81|
        endif
    endif
    call winrestview(l:winview)
endfunction

"--------------------------------------------------------------------------------
" Rename file and make appropriate buffer changes
function! s:rename_file(new_file_path) abort
  execute 'saveas ' . a:new_file_path
  call delete(expand('#:p'))
  bd #
endfunction

command! -nargs=1 -complete=file Rename call <SID>rename_file(<f-args>)

"--------------------------------------------------------------------------------
" Auto increment numbers
function! Incr() abort
    let l:a = line('.') - line("'<")
    let l:c = virtcol("'<")
    if l:a > 0
        execute 'normal! ' . l:c . '|' . l:a . "\<C-a>"
    endif
    normal `<
endfunction
vnoremap <C-a> :call Incr()<CR>

"--------------------------------------------------------------------------------
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

"--------------------------------------------------------------------------------
" Toggle ignore whitespaces (VimDiff or GitGutter)
function! ToggleIgnoreWhite() abort
    if g:gitgutter_diff_args =~ '-w'
        let g:gitgutter_diff_args = ''
        GitGutter
        echo "-iwhite"
    elseif g:gitgutter_diff_args !~ '-w'
        let g:gitgutter_diff_args = '-w'
        GitGutter
        echo "+iwhite"
    endif
endfunction
map <F6> :call ToggleIgnoreWhite()<CR>"


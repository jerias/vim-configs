"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colorscheme related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let base16ScriptPath = expand("$HOME/.config/base16-shell/scripts/")
if isdirectory(base16ScriptPath)
    let g:base16_shell_path = base16ScriptPath
endif

function! s:base16_customize() abort
    let current_scheme = get(g:, 'colors_name', 'default')
    if current_scheme =~ 'base16'
        call Base16hi("Search",        g:base16_gui0A, g:base16_gui01, g:base16_cterm0A, g:base16_cterm01,  "reverse", "")
        call Base16hi("Search",        g:base16_gui0A, g:base16_gui01, g:base16_cterm0A, g:base16_cterm01,  "reverse", "")
        call Base16hi("Constant",      g:base16_gui0B, "", g:base16_cterm0B, "", "", "")
        call Base16hi("Deprecated",   "", "", "", "", "", "")
    endif
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

if exists('$BASE16_THEME')
      \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif

"set background=dark
"if filereadable(expand("~/.vimrc_background"))
"    let base16colorspace=256
"    source ~/.vimrc_background
"else
"    colorscheme solarized
"endif

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
autocmd! bufwritepost vimrc source ~/.vim/vimrcs/vimrc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim/temp_dirs/undodir
    set undofile
catch
endtry


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
" => Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vnoremap $1 <esc>`>a)<esc>`<i(<esc>
" vnoremap $2 <esc>`>a]<esc>`<i[<esc>
" vnoremap $3 <esc>`>a}<esc>`<i{<esc>
" vnoremap $$ <esc>`>a"<esc>`<i"<esc>
" vnoremap $q <esc>`>a'<esc>`<i'<esc>
" vnoremap $e <esc>`>a"<esc>`<i"<esc>
"
" " Map auto complete of (, ", ', [
" inoremap $1 ()<esc>i
" inoremap $2 []<esc>i
" inoremap $3 {}<esc>i
" inoremap $4 {<esc>o}<esc>O
" inoremap $q ''<esc>i
" inoremap $e ""<esc>i
" inoremap $t <><esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif

    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc


"--------------------------------------------------------------------------------
" Clean up files - remove trailing white space - converte tabs to spaces, convert to UNIX newlines
function! CleanUpThis()
    exe "normal mz"
    setlocal ff=unix
    silent! %s/\r//g
    if &filetype != "make"
        silent! %s/\t/    /g
    endif
    silent! %s/\s\+$//ge
    exe "normal `z"
endfunction

autocmd! BufWrite           * call CleanUpThis()

" Makefiles need tabs...
autocmd! FileType           make setlocal noexpandtab
autocmd! FileType           yaml setlocal ts=2 sts=2 sw=2 expandtab

"--------------------------------------------------------------------------------
" Set titlebar to something useful
set titlelen=200
function! SetWindowName()
    let filename        =expand("%:t")
    let filepath        =expand("%:p")
    let mypwd           =expand("%:{getcwd()}")
    let modified        ="%M"
    " TODO: Fix this substitution
    let viewname        =substitute(filepath, "\(mywcps\/\S*\)\/\.\*", "\1", 0)
    let viewname        =substitute(viewname, "\.\*\/", "", 0)
    if viewname == filename
        let &titlestring    =modified . v:servername . " - " . filepath
    else
        let &titlestring    =modified . v:servername . " - <" . viewname . "> - " . filepath
    endif
endfunction

autocmd! BufEnter           * call SetWindowName()

"--------------------------------------------------------------------------------
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

"--------------------------------------------------------------------------------
" Git macros
function! GitDiff()
    exe '!git diff % 2>&1'
endfunction
map <F5> :call GitDiff()<CR>

"--------------------------------------------------------------------------------
"add exec perms and execute the file
nnoremap <silent> <F7> :!chmod +x %<CR>
cnoremap <silent> <F7> <Esc>:!chmod +x %<CR>
inoremap <silent> <F7> <Esc>:!chmod +x %<CR>a

"--------------------------------------------------------------------------------
function! <SID>FindWindow(bufName, doDebug)
  " Try to find an existing window that contains
  " our buffer.
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

" don't store any options in sessions
if version >= 700
    set sessionoptions=blank,buffers,curdir,tabpages,winpos,folds
endif

" automatically update session, if loaded
let s:sessionloaded = 0
let s:sessionName = ""
function! LoadSession()
    echo "Loading Session..."
    if s:sessionName == ""
        echo "No session name set"
        call GetSessionName()
    endif

    if filereadable(s:sessionName)
        execute "source ".s:sessionName
        if bufexists(1)
          for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
              exec 'sbuffer ' . l
            endif
          endfor
        endif

        let s:sessionloaded = 1
        echo "Loaded session:".s:sessionName
    endif

endfunction

function! SaveSession()
    echo "Saving Session..."
    if s:sessionName == ""
        echo "No session name set"
        call GetSessionName()
    endif

    execute "mksession! ".s:sessionName
    echo "Saving session:".s:sessionName
endfunction

function! GetSessionName()
    let curline = getline('.')
    call inputsave()
    let s:sessionName = input('Enter Session Name: ')
    call inputrestore()
    let s:sessionName = $HOME."/.vim/temp_dirs/sessions/".s:sessionName
    echo "Session is :".s:sessionName
endfunction

function! SaveSessionOnClose()
    if s:sessionName == ""
        let s:sessionName = $HOME."/.vim/temp_dirs/sessions/"."lastsession"
    endif
    call SaveSession()
endfunction

function! LoadSessionServerName()
    if v:servername != "" && v:servername != "GVIM"

        let s:sessionName = tolower($HOME."/.vim/temp_dirs/sessions/".v:servername)
        if filereadable(s:sessionName)
            call LoadSession()
        endif
    endif
endfunction


autocmd VimLeave * call SaveSessionOnClose()

autocmd VimEnter * nested call LoadSessionServerName()

"--------------------------------------------------------------------------------
" Verilog stuff

let @z="_v48|c.lyeE50i pBd49|i(Ai)j"

let g:moduleName = "dummy_inst"
noremap <F9> :call FormatToInstanceLine()<CR>
function! FormatToInstanceLine()
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

    elseif instCurLine =~ "^ *module"
        "----- Store module name
        let g:moduleName = split(instCurLine)[1]
        " Remove any paranetheses (handle moving these below)
        let g:moduleName = substitute(g:moduleName,"#(\\|(","","")
        call setline('.', "    " . g:moduleName)
        if instNextLine =~ "^ *("
            exec "s/$/\r"
            call setline('.', "    " . "u_" . g:moduleName)
        endif
        if instCurLine =~ "#( *$"
            "----- Try to clean up parentheses on wrong lines
            exec "s/$/\r"
            call setline('.', "    #(")
        elseif instCurLine =~ "( *$"
            "----- Try to clean up parentheses on wrong lines
            exec "s/$/\r"
            call setline('.', "    (")
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
        exec "s/$/\r"
        call setline('.', "    #(")

    elseif instCurLine =~ "^ *( *$"
        "----- Just indent stand-alone "("
        call setline('.', substitute(instCurLine,"^ *","    ",""))

    elseif instCurLine =~ "^ *("
        "----- Separate "#(" from rest of line
        call setline('.', substitute(instCurLine,"^ *(","",""))
        normal k
        exec "s/$/\r"
        call setline('.', "    (")

    elseif instCurLine =~ "^ *);"
        "----- Just indent stand-alone ");"
        call setline('.', substitute(instCurLine,"^ *","    ",""))

    elseif instCurLine =~ "); *$"
        "----- Separate "); from rest of line
        call setline('.', substitute(instCurLine,");","",""))
        exec "s/$/\r"
        call setline('.', "    );")
        normal k
        call FormatToInstanceLine()

    elseif instCurLine =~ "^ *)"
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
            exec "s/$/\r"
            call setline('.', "    " . "u_" . g:moduleName)
            " Clear after use as instance
            let g:moduleName = "dummy_inst"
        endif

    elseif (instCurLine =~ ") *$") && !(instNextLine =~ "^ *)") && !(instCurLine =~ "(")
        "----- Separate ") from rest of line
        call setline('.', substitute(instCurLine,")","",""))
        exec "s/$/\r"
        call setline('.', "    )")
        normal k
        call FormatToInstanceLine()

    elseif instNextLine =~ "^ *#(" || instNextLine =~ "^ *("
        "----- This should be the case were there is a bare word module or instance name
        "----- above an open parentheses. - Do nothing

    else
        "--------------------------------------------------------------------------------
        "--------------------------------------------------------------------------------
        "----- Paramters and ports

        "----- A few items are different for parameters
        if instCurLine=~"^ *parameter"
            let nameIndex = "1"
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
        if instCurLine =~ "{"
            let sigName = substitute(instCurLine,".*(\\({.*}\\)).*", "\\1", "")
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
function! FormatToInstance()
    let l:winview = winsaveview()
    let curline=""
    while  !(curline=~"^ *);")
        let curline=getline('.')
        call FormatToInstanceLine()
        normal j
    endwhile
    call winrestview(l:winview)
endfunction

" TODO: noremap <F8> :call FormatPortLine()<CR>
function! FormatPortLine()
    let l:winview = winsaveview()
    let curline=getline('.')
    if curline=~"^ *input" || curline=~"^ *output" || curline=~"^ *inout"
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
function! s:rename_file(new_file_path)
  execute 'saveas ' . a:new_file_path
  call delete(expand('#:p'))
  bd #
endfunction

command! -nargs=1 -complete=file Rename call <SID>rename_file(<f-args>)

"--------------------------------------------------------------------------------
" Auto increment numbers
function! Incr()
    let a = line('.') - line("'<")
    let c = virtcol("'<")
    if a > 0
        execute 'normal! '.c.'|'.a."\<C-a>"
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
function! ToggleIgnoreWhite()
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


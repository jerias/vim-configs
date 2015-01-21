"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark

if has("gui_running")
    colorscheme ir_black_jpm
else
    colorscheme ir_black_jpm
endif

" Set font according to system
if has("mac") || has("macunix")
    set gfn=Menlo:h14
    set shell=/bin/bash
elseif has("win16") || has("win32")
    set gfn=Bitstream\ Vera\ Sans\ Mono:h10
elseif has("linux")
    set gfn=Monospace\ 10
    set shell=/bin/bash
endif

" Open MacVim in fullscreen mode
if has("gui_macvim")
    set fuoptions=maxvert,maxhorz
    au GUIEnter * set fullscreen
endif

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L


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
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a"<esc>`<i"<esc>

" Map auto complete of (, ", ', [
inoremap $1 ()<esc>i
inoremap $2 []<esc>i
inoremap $3 {}<esc>i
inoremap $4 {<esc>o}<esc>O
inoremap $q ''<esc>i
inoremap $e ""<esc>i
inoremap $t <><esc>i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General abbreviations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS



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
nmap <C-F12> <ESC>:call LoadSession()<CR>
nmap <C-F11> <ESC>:call SaveSession()<CR>
nmap <C-F10> <ESC>:call GetSessionName()<CR>

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

    let l:winNum = <SID>FindWindow('-TabBar-', 1)
    TbStop

    execute "source ".s:sessionName
    let s:sessionloaded = 1
    if l:winNum != -1
        TbStart
    endif
    echo "Loaded session:".s:sessionName
endfunction

function! SaveSession()
    echo "Saving Session..."
    if s:sessionName == ""
        echo "No session name set"
        call GetSessionName()
    endif

    " Close minibufexplorer
    let l:winNum = <SID>FindWindow('-TabBar-', 1)
    TbStop
    execute "mksession! ".s:sessionName
    if l:winNum != -1
        TbStart
    endif
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

autocmd VimLeave * call SaveSessionOnClose()

"--------------------------------------------------------------------------------
" Verilog stuff

let @z="_v48|c.lyeE50i pBd49|i(Ai)j"

noremap <F9> :call FormatToInstanceLine()<CR>
function! FormatToInstanceLine()
    " Has issues when wrap is enabled - temporarily disable if it's on
    let l:mywrap = &wrap
    setlocal nowrap
    let l:winview = winsaveview()
    let curline=getline('.')
    if curline=~"^ *input" || curline=~"^ *output" || curline=~"^ *inout" || curline=~"^ *lal_intf" || curline=~"^ *al_intf" || curline=~"^ *il_intf" || curline=~"^ *gen_clock_s" || curline=~"^ *interface"
        "normal $
        "let endchar=getline('.')[col('.')-1]
        "if endchar == "," || endchar == ";"

        if     curline =~ "/" && !(curline =~ "[,;].*/")
            normal _f/Bd^i.lyeE50a pBd49|i(Ea)f/90i ld89|
        elseif curline =~ "[,;].*/"
            if      curline =~ ",.*/"
                normal _f,xBd^i.lyeE50a pBd49|i(Ea)a,f/40i ld89|
            elseif  curline =~ ";.*/"
                normal _f;xBd^i.lyeE50a pBd49|i(Ea)a,f/40i ld89|
            endif
        elseif  curline =~ ","
            normal _f,xBd^i.lyeE50a pBd49|i(Ea)a,
        elseif  curline =~ ";"
            normal _f;xBd^i.lyeE50a pBd49|i(Ea)a,
        else
            normal  $Bd^i.lyeE50a pBd49|i(Ea)
        endif


        "if curline =~ ","
        "    normal _f,xBd^i.lyeE50a pBd49|i(Ea)a,
        "elseif curline =~ ";"
        "    normal _f;xBd^i.lyeE50a pBd49|i(Ea)a,
        "elseif curline =~ "/"
        "    normal _f/Bd^i.lyeE50a pBd49|i(Ea)a,
        "else
        "    normal  $Bd^i.lyeE50a pBd49|i(Ea)
        "endif
    elseif curline=~"^ *parameter"
        if  curline =~ ","
            normal _f,x_vwhc.Eld$BlyeE50a 49|
            let char = getline('.')[col('.')-1]
            if char == " "
                normal $pBd49|i(Ea)a,
            else
                normal _eld$byeea (pa),
            endif
        elseif  curline =~ ";"
            normal _f;x_vwhc.Eld$BlyeE50a pBd49|i(Ea)a,
        else
            normal  _vwhc.Eld$BlyeE50a pBd49|i(Ea)
        endif
    endif
    call winrestview(l:winview)
    " Restore previous wrap setting
    if l:mywrap
        set wrap
    endif
endfunction

noremap <C-F9> :call FormatToInstance()<CR>
function! FormatToInstance()
    let l:winview = winsaveview()
    let curline=""
    while  !(curline=~");")
        let curline=getline('.')
        call FormatToInstanceLine()
        normal j
    endwhile
    call winrestview(l:winview)
endfunction

noremap <F8> :call FormatPortLine()<CR>
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


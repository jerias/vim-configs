"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:verilog_disable_indent_lst = ['interface']
let g:hl_matchit_enable_on_vim_startup = 1

""""""""""""""""""""""""""""""
" => Load pathogen paths
""""""""""""""""""""""""""""""
call pathogen#infect('~/.vim/plugins_git')
call pathogen#infect('~/.vim/plugins_github_mine')
call pathogen#infect('~/.vim/plugins_nogit')
call pathogen#helptags()

""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>


"" """"""""""""""""""""""""""""""
"" " => YankRing
"" """"""""""""""""""""""""""""""
"" if has("win16") || has("win32")
""     " Don't do anything
"" else
""     let g:yankring_history_dir = '~/.vim/temp_dirs/'
"" endif


""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

"" let g:ctrlp_map = '<c-f>'
"" map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>

function! TNERDTree()
    NERDTreeToggle
    "TbToggle
endfunction

map <F4> :call TNERDTree()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffergator
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:buffergator_autoexpand_on_split = 0
let g:buffergator_sort_regime         = "filepath"

map <F3> :BuffergatorToggle<CR>
map <S-F3> :BuffergatorUpdate<CR>

" Stop buffer flyout from resizing other windows
set noequalalways

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => AirLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:airline#extensions#tabline#enabled = 0
"let g:airline_powerline_fonts = 0
"" unicode symbols
"let g:airline_symbols = {}
if has("multi_byte")
"    "let g:airline_left_sep = '▶'
    let g:airline_left_sep = ''
"    let g:airline_left_alt_sep = ''
"    "let g:airline_right_sep = '◀'
    let g:airline_right_sep = ''
"    let g:airline_right_alt_sep = ''
"    let g:airline_symbols.linenr = '␊'
"    let g:airline_symbols.branch = '⎇'
"    "let g:airline_symbols.paste = 'ρ'
"    "let g:airline_symbols.whitespace = 'Ξ'
endif
let g:airline_stl_path_style = 'short'
"
"let g:airline_theme="luna"
let g:airline_theme="dark"
set showtabline=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Indent guide
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:indent_guides_enable_on_vim_startup=1
" let g:indent_guides_auto_colors = 0
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#151515   ctermbg=black
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#111111 ctermbg=darkgrey

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => verilog_systemverilog
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" goto instance top
map <leader>u :VerilogGotoInstanceStart<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => hl_matchit
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" If this variable is set, augroup is defined, and start highlighting.
let g:hl_matchit_enable_on_vim_startup = 1

"" you can specify highlight group. see :highlight
let g:hl_matchit_hl_groupname = 'MatchParen'

"" I recomend  g:hl_matchit_speed_level = 1 because highlight is
"" just an addition.
"" If 1 is set, sometimes do not highlight.
let g:hl_matchit_speed_level = 1 " or 2

"" you can specify use hl_matchit filetype.
"let g:hl_matchit_allow_ft = 'html,vim,sh' " blah..blah..


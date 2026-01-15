"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"let g:verilog_disable_indent_lst = ['interface']
let g:verilog_disable_indent_lst="eos,standalone,moduleports"

""""""""""""""""""""""""""""""
" => Load pathogen paths
""""""""""""""""""""""""""""""
call pathogen#infect('~/.vim/plugins_git')
call pathogen#infect('~/.vim/plugins_github_mine')
call pathogen#infect('~/.vim/plugins_nogit')
call pathogen#infect('~/.local/share/tinted-theming/tinty/repos/base16-vim/')
call pathogen#helptags()


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
"if has("multi_byte")
""    "let g:airline_left_sep = '▶'
"    let g:airline_left_sep = ''
""    let g:airline_left_alt_sep = ''
""    "let g:airline_right_sep = '◀'
"    let g:airline_right_sep = ''
""    let g:airline_right_alt_sep = ''
""    let g:airline_symbols.linenr = '␊'
""    let g:airline_symbols.branch = '⎇'
""    "let g:airline_symbols.paste = 'ρ'
""    "let g:airline_symbols.whitespace = 'Ξ'
"endif
let g:airline_stl_path_style = 'short'
"
"let g:airline_theme="luna"
"let g:airline_theme="dark"
let g:airline_theme="lightjpm"
set showtabline=0

let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

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

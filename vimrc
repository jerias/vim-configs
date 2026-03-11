set runtimepath^=~/.vim

" XDG Base Directory paths for vim
let g:vim_config_dir  = expand("$HOME/.vim")
let g:vim_data_dir    = expand("$HOME/.local/share/vim")
let g:vim_state_dir   = expand("$HOME/.local/state/vim")
let g:vim_sessions_dir = g:vim_state_dir . "/sessions"

" Initialize vim-plug
call plug#begin(g:vim_data_dir . '/plugged')

" Standard plugins
Plug 'preservim/nerdtree'
Plug 'godlygeek/tabular'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'

" Custom forks - using your repositories
Plug 'jerias/vim-airline-themes'
" Plug 'jerias/verilog_systemverilog.vim'  " replaced by ~/.vim/indent/systemverilog.vim + ~/.vim/after/syntax/systemverilog.vim
Plug 'jerias/vim-buffergator'

call plug#end()

" Load matchit plugin for % matching (required by verilog plugin)
runtime macros/matchit.vim

" Source configuration files
source ~/.vim/vimrcs/basic.vim
source ~/.vim/vimrcs/plugins_config.vim
source ~/.vim/vimrcs/extended.vim


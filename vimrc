set runtimepath^=~/.vim

" Initialize vim-plug
call plug#begin('~/.vim/plugged')

" Standard plugins
Plug 'preservim/nerdtree'
Plug 'godlygeek/tabular'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'

" Custom forks - using your repositories
Plug 'jerias/vim-airline-themes'
Plug 'jerias/verilog_systemverilog.vim'
Plug 'jerias/vim-buffergator'

call plug#end()

" Load matchit plugin for % matching (required by verilog plugin)
runtime macros/matchit.vim

" Source configuration files
source ~/.vim/vimrcs/basic.vim
source ~/.vim/vimrcs/plugins_config.vim
source ~/.vim/vimrcs/extended.vim


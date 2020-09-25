syntax on
set encoding=UTF-8
set nowrap
set ai
set tabstop=2
set ls=2
set autoindent
set smartindent
set incsearch
set clipboard+=unnamedplus
set shiftwidth=2

call plug#begin('~/.local/share/nvim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/goyo.vim'
Plug 'racer-rust/vim-racer'
call plug#end()

set statusline=
set statusline+=%#PmenuSel#
set statusline+=\ %m 
set statusline+=\ [%F] 
set statusline+=%= "Right side settings
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %l/%L
set statusline+=\ %c 
set statusline+=\ %p%% 

nmap<C-f> :NERDTreeToggle<CR>
nmap<C-g> :Goyo<CR>

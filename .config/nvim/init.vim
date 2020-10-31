syntax on
set encoding=UTF-8
set number
set nowrap
set ai
set nobackup
set ls=2
set autoindent
set smartindent
set incsearch
set shiftwidth=2

set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

call plug#begin('~/.local/share/nvim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/goyo.vim'
" Plug 'racer-rust/vim-racer'
" Plug 'rust-lang/rust.vim'
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

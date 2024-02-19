#!/bin/bash

"
"       ███╗   ██╗██╗██╗  ██╗ █████╗ ██████╗ ███████╗
"       ████╗  ██║██║██║  ██║██╔══██╗██╔══██╗██╔════╝
"       ██╔██╗ ██║██║███████║███████║██████╔╝███████╗
"       ██║╚██╗██║██║██╔══██║██╔══██║██╔══██╗╚════██║
"       ██║ ╚████║██║██║  ██║██║  ██║██║  ██║███████║
"       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
"       DRAFTED BY [https://nih.ar] ON 10-04-2020.
"       SOURCE [init.vim] LAST MODIFIED ON 18-02-2024.
"

" GENERAL
let mapleader =","
syntax on 
set encoding=UTF-8
set title

" VIM PLUG INSTALL
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif
filetype plugin indent on " required
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

" PLUGINS
call plug#begin("$XDG_CONFIG_HOME/nvim/plugged")
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/goyo.vim'
Plug 'ap/vim-css-color' " Color previews for CSS
Plug 'itchyny/lightline.vim'
" Plug 'racer-rust/vim-racer'
" Plug 'rust-lang/rust.vim'
call plug#end()

" INDENTATION
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" NUMBER
set number relativenumber

" SEARCH
set incsearch " Dynamically search while typing characters.
set hlsearch " Highlight search results
set ignorecase
set smartcase

" NO BACKUP
set noswapfile
set nobackup
set nowritebackup

" OTHER
set laststatus=2 " set last status 
set scrolloff=5 " Scroll off will put z+<enter> cursor at 5th line from top. 
set wildmenu " Wildmenu for autocomplete in command mode.
set nowrap " No wrapping
set hidden " Needed to keep multiple buffers open
set t_Co=256
" Copy/Paste/Cut
if has('unnamedplus')
 set clipboard=unnamed,unnamedplus
endif

" PLUGINS ACTIVATION
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38
let NERDTreeMapOpenInTab='<ENTER>'
let g:lightline = { 'colorscheme': 'nord'} " to check other themes :h g:lightline.colorscheme

" VIM KEYBINDINGS
inoremap jk <esc>
map <leader>w :w!<CR>
map <leader>l :bn!<CR>
map <leader>n :NERDTreeToggle<CR>
map <leader>g :Goyo<CR>
map <leader>b :bufdo tab split<CR>
map <leader>o :tabnew<CR>
nnoremap <silent> <leader>sh :terminal<CR>
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>
" Remap splits navigation to just CTRL + hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
noremap <silent> <C-Left> :vertical resize +3<CR>
noremap <silent> <C-Right> :vertical resize -3<CR>
noremap <silent> <C-Up> :resize +3<CR>
noremap <silent> <C-Down> :resize -3<CR>

" CACHE setup
set directory=$XDG_CACHE_HOME/vim/swap,~/,/tmp
set backupdir=$XDG_CACHE_HOME/vim/backup,~/,/tmp
set undodir=$XDG_CACHE_HOME/vim/undo,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo



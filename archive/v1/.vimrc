" Vundle Start
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'NLKNguyen/papercolor-theme'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Vundle End

set t_Co=256   " This is may or may not needed.
set background=light
colorscheme PaperColor


" Custom
set list
syntax on
set mouse=a

" OLD vimrc
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" Disable arrows
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap <left> :tabprevious<CR>
nnoremap <right> :tabnext<CR>

" easier split navigation
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" jj to normalmode
inoremap jj <Esc>


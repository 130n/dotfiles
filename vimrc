" Note: Skip initialization for vim-tiny or vim-small.
if 1
  execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'
endif
" vim:set et sw=2
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

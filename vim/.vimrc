" DEFAULTS ------------------------------------------------------------ {{{
set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on
set number
set shiftwidth=4
set tabstop=4
set expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set smartcase
set showmatch
set hlsearch
set history=1000

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}

" Plugins ------------------------------------------------------------ {{{
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'tpope/vim-surround'
Plug 'rstacruz/vim-closer'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-endwise'
Plug 'tomtom/tcomment_vim'
Plug 'xavierd/clang_complete'
Plug 'lifepillar/vim-mucomplete'
Plug 'fionn/grb256'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-dispatch'

call plug#end()

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

set background=dark
colorscheme grb256

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

set noinfercase
set completeopt-=preview
set completeopt+=menuone,noselect
" The following line assumes `brew install llvm` in macOS
let g:clang_library_path = '/usr/local/opt/llvm/lib/libclang.dylib'
let g:clang_user_options = '-std=c++17'
let g:clang_complete_auto = 1
let g:mucomplete#enable_auto_at_startup = 1
" }}}

" STATUS LINE ------------------------------------------------------------ {{{
set statusline=
set statusline+=\ %F\ %M\ %Y\ %R
set statusline+=%=
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
set laststatus=2
" }}}

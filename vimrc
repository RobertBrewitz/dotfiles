scriptencoding utf-8

" Encoding
set encoding=utf-8

" Colors
set termguicolors

" Backups
set undofile
set undolevels=1000
set undoreload=10000

set backup
set swapfile
set undodir=$HOME/.vim/tmp/undo
set backupdir=$HOME/.vim/tmp/backup
set directory=$HOME/.vim/tmp/swap

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" Being considerate
set nocompatible
set secure
set ff=unix

" Completion
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Allow backspace
set backspace=indent,eol,start

" Syntax highlighting
syntax on

" Indentation & whitespace
set autoindent
set smartindent
set shiftwidth=2
set expandtab
set tabstop=2
set listchars=tab:▸\ ,eol:¬,trail:·
set list

" Gutter
set number

" Command timeouts
set timeoutlen=1000
set ttimeoutlen=0

" Status
set showtabline=2
set laststatus=2

" Sign column
set signcolumn=yes

" Folding
set nofoldenable

" Misc
set nobackup
set nowritebackup
set nostartofline
set scrolloff=5
set history=1000
set cmdheight=1
set shortmess+=c
set updatetime=300

" Remaps
nnoremap <silent> <S-k> :tabn <cr> :call coc#float#close_all() <cr>
nnoremap <silent> <S-j> :tabp <cr> :call coc#float#close_all() <cr>
nnoremap <C-p> :FZF<cr>
nnoremap ; :

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path-relative)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Plugins
call plug#begin('~/.vim/plugged')
  " Formatting
  Plug 'editorconfig/editorconfig-vim'

  " Utilities
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'

  " Fuzzy finding
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Syntax Highlighting
  Plug 'pangloss/vim-javascript'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'peitalin/vim-jsx-typescript'
  Plug 'leafgarland/typescript-vim'
  Plug 'hashivim/vim-terraform'
  Plug 'jparise/vim-graphql'
  Plug 'lepture/vim-velocity'

  au BufNewFile,BufRead *.vtl set ft=velocity

  " Theme
  Plug 'nanotech/jellybeans.vim'
  let g:jellybeans_overrides = {
 \  'background': { 'guibg': '000000' },
 \  'SignColumn': { 'guibg': '000000' },
 \  'Pmenu': { 'guibg': '111111' },
 \  'PmenuSel': { 'guibg': 'eeeeee' },
 \  'PmenuSbar': { 'guibg': '111111' },
 \  'PmenuThumb': { 'guibg': '111111' },
 \}

  " Language Servers
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_disable_startup_warning = 1
  au BufNewFile,BufRead *.ts setlocal filetype=typescript
  au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <leader>rn <Plug>(coc-rename)

call plug#end()

" Theme
color jellybeans

" Load environment specific vim config
let $VIMRC_OSX=$HOME . '/.vimrc_osx'
if filereadable(expand($VIMRC_OSX))
  source $VIMRC_OSX
endif

let $VIMRC_CHRONOS=$HOME . '/.vimrc_chronos'
if filereadable(expand($VIMRC_CHRONOS))
  source $VIMRC_CHRONOS
endif

let $VIMRC_WSL=$HOME . '/.vimrc_wsl'
if filereadable(expand($VIMRC_WSL))
  source $VIMRC_WSL
endif

let $VIMRC_UBUNTU=$HOME . '/.vimrc_ubuntu'
if filereadable(expand($VIMRC_UBUNTU))
  source $VIMRC_UBUNTU
endif

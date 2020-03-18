scriptencoding utf-8

" Encoding
set encoding=utf-8

" Being considerate
set nocompatible
set secure
set ff=unix

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
set number relativenumber

" Command timeouts
set timeoutlen=1000
set ttimeoutlen=0

" Status
set showtabline=2
set laststatus=2

" Sign column
set signcolumn=yes

" Tags
set tags=tags;/
set tags+=tstags;/
set tags+=jstags;/
nnoremap <C-j> <C-w><C-]><C-w>T

" Folding
set nofoldenable

" Misc
set nostartofline
set scrolloff=5
set history=1000
set shortmess=atITA
set cmdheight=1

" Remaps
nnoremap <S-k> :tabn<cr>
nnoremap <S-j> :tabp<cr>
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
  Plug 'prettier/vim-prettier', { 'do': 'npx yarn install' }

  " Utilities
  Plug 'tpope/vim-surround'

  " Fuzzy finding
  Plug 'junegunn/fzf'
  Plug 'RobertBrewitz/fzf.vim'

  " Syntax Highlighting
  Plug 'pangloss/vim-javascript'
  Plug 'MaxMEllon/vim-jsx-pretty'
  Plug 'leafgarland/typescript-vim'
  Plug 'ianks/vim-tsx'

  " Theme
  Plug 'nanotech/jellybeans.vim'

  " Language Servers
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  au BufNewFile,BufRead *.ts setlocal filetype=typescript
  au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
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

scriptencoding utf-8

" Encoding
set encoding=utf-8

" Being considerate
set nocompatible
set secure
set ff=unix

" Project .vimrc
set exrc

" Colors
set termguicolors

" Errorbell
set noerrorbells
set belloff=all

" Inc/dec
set nrformats-=octal

" Undo/Backup/Swap
set directory=.,~/.vim/tmp,~/tmp,/var/tmp,/tmp
set nobackup
set noswapfile
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.vim/tmp/undo
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif

" Completion
set completeopt=menuone,noinsert,noselect
set complete-=i
set wildmenu
set wildoptions=tagfile
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Allow backspace
set backspace=indent,eol,start

" Syntax highlighting
syntax on

" Tabs
set tabpagemax=50

" Formatting
set formatoptions-=cro
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=2 softtabstop=2
set colorcolumn=80
set shiftwidth=2
set listchars=tab:▸\ ,eol:¬,trail:·
set list

" Buffers & Terminal
set hidden
set switchbuf=uselast

" Gutter
set number
" set relativenumber

" Command timeouts
set showcmd
set notimeout
set ttimeout
set timeoutlen=1000
set ttimeoutlen=0

" Status
set showtabline=2
set laststatus=2
set statusline=%F
set ruler

" Sign column
set signcolumn=yes

" Folding
set fdm=indent fdls=2 fdn=2

" Search
set incsearch

" Misc
set autoread
set nowritebackup
set nostartofline
set scrolloff=5
set sidescrolloff=5
set history=10000
set cmdheight=1
set shortmess+=c
set updatetime=300
set display+=lastline
set autoread
set tabpagemax=50
set sessionoptions-=options
set sessionoptions+=unix,slash
set viewoptions-=options
set viewoptions+=unix,slash
set viminfo+=!

" Soft wrapping text
" set wrap
" set linebreak

" Remaps
set langnoremap
set nolangremap
nnoremap <SPACE> <Nop>
let mapleader = " "
nnoremap <silent> <S-k> :tabn <cr>
nnoremap <silent> <S-j> :tabp <cr>
nnoremap <silent> <C-k> :call CocAction('diagnosticNext') <cr>
nnoremap <silent> <C-j> :call CocAction('diagnosticPrevious') <cr>
nnoremap <silent> <leader>j :cprev <cr>zzzv
nnoremap <silent> <leader>k :cnext <cr>zzzv
nnoremap <silent> <C-p> :Files <cr>
nnoremap <silent> <leader>p :Buffers <cr>
nnoremap ; :
nnoremap n nzzzv
nnoremap N Nzzzv
"nnoremap J mzJ`z :delm m<CR>
nnoremap Y y$
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <c-k> <esc>:m .-2<CR>i
inoremap <c-j> <esc>:m .+1<CR>i
"nnoremap <leader>k :m .-2<CR>==
"nnoremap <leader>j :m .+1<CR>==
nnoremap <silent> <leader>d :call <SID>show_documentation()<CR>

" Functions
"
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

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
 \  'Folded': { 'guibg': '000000', 'guifg': '555555' },
 \  'ColorColumn': { 'guibg': '111111' },
 \  'SpecialKey': { 'guibg': '000000', 'guifg': '555555' },
 \  'NonText': { 'guibg': '000000', 'guifg': '555555' },
 \}

  " Language Servers
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_disable_startup_warning = 1
  au BufNewFile,BufRead *.ts setlocal filetype=typescript
  au BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
  nmap <silent> <leader>gd <Plug>(coc-definition)
  nmap <silent> <leader>gy <Plug>(coc-type-definition)
  nmap <silent> <leader>gi <Plug>(coc-implementation)
  nmap <silent> <leader>gr <Plug>(coc-references)
  nmap <silent> <leader>rn <Plug>(coc-rename)
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

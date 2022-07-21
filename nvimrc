scriptencoding utf-8

" - Filetype detection is enabled by default. This can be disabled by adding
"   ":filetype off" to |init.vim|.
" - Syntax highlighting is enabled by default. This can be disabled by adding
"   ":syntax off" to |init.vim|.
"
" DONE- 'autoindent' is enabled
" DONE - 'autoread' is enabled
" DONE - 'background' defaults to "dark" (unless set automatically by the terminal/UI)
" DONE - 'backspace' defaults to "indent,eol,start"
" - 'backupdir' defaults to .,~/.local/state/nvim/backup// (|xdg|), auto-created
" DONE - 'belloff' defaults to "all"
" DONE - 'compatible' is always disabled
" DONE - 'complete' excludes "i"
" KEEP FOR NOW - 'cscopeverbose' is enabled
" DONE - 'directory' defaults to ~/.local/state/nvim/swap// (|xdg|), auto-created
" DONE - 'display' defaults to "lastline,msgsep"
" DONE - 'encoding' is UTF-8 (cf. 'fileencoding' for file-content encoding)
" KEEP FOR NOW - 'fillchars' defaults (in effect) to "vert:│,fold:·,sep:│"
" KEEP FOR NOW - 'formatoptions' defaults to "tcqj"
" DONE - 'fsync' is disabled
" DONE - 'hidden' is enabled
" DONE - 'history' defaults to 10000 (the maximum)
" DONE - 'hlsearch' is enabled
set nohlsearch
" DONE - 'incsearch' is enabled
" DONE - 'joinspaces' is disabled
" DONE - 'langnoremap' is enabled
" DONE - 'langremap' is disabled
" DONE - 'laststatus' defaults to 2 (statusline is always shown)
" DONE - 'listchars' defaults to "tab:> ,trail:-,nbsp:+"
" DONE - 'nrformats' defaults to "bin,hex"
" DONE - 'ruler' is enabled
" DONE - 'sessionoptions' includes "unix,slash", excludes "options"
" DONE - 'shortmess' includes "F", excludes "S"
" DONE - 'showcmd' is enabled
" DONE - 'sidescroll' defaults to 1
set sidescroll=0
" DONE - 'smarttab' is enabled
" DONE - 'startofline' is disabled
" DONE - 'switchbuf' defaults to "uselast"
" DONE - 'tabpagemax' defaults to 50
" INVESTIGATE - 'tags' defaults to "./tags;,tags"
" DONE - 'ttimeoutlen' defaults to 50
set ttimeoutlen=0
" DONE - 'ttyfast' is always set
" DONE - 'undodir' defaults to ~/.local/state/nvim/undo// (|xdg|), auto-created
" DONE - 'viewoptions' includes "unix,slash", excludes "options"
" DONE - 'viminfo' includes "!"
" DONE - 'wildmenu' is enabled
" DONE - 'wildoptions' defaults to "pum,tagfile"
"
" - |man.vim| plugin is enabled, so |:Man| is available by default.
" - |matchit| plugin is enabled. To disable it in your config:
"     :let loaded_matchit = 1
"
" - |g:vimsyn_embed| defaults to "l" to enable Lua highlighting

" Being considerate
set secure
set ff=unix

" Project .vimrc
set exrc

" Colors
set termguicolors

" Errorbell
set noerrorbells

" Undo/Backup/Swap
set directory=.,~/.nvim/tmp,~/tmp,/var/tmp,/tmp
set nobackup
set noswapfile
set undofile
set undolevels=1000
set undoreload=10000
set undodir=$HOME/.nvim/tmp/undo
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p")
endif

" Completion
set completeopt=menuone,noinsert,noselect
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Formatting
set formatoptions-=cro
set smartindent
set expandtab
set tabstop=2 softtabstop=2
set colorcolumn=80
set shiftwidth=2
set listchars=tab:▸\ ,eol:¬,trail:·
set list

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
set statusline=%F

" Sign column
set signcolumn=yes

" Folding
set fdm=indent fdls=2 fdn=2

" Misc
set nowritebackup
set nostartofline
set scrolloff=5
set sidescrolloff=5
set cmdheight=1
set shortmess+=c
set updatetime=300

" Writing
set fsync

" Remaps
nnoremap <SPACE> <Nop>
let mapleader = " "
nnoremap <silent> <S-k> :tabn <cr>
nnoremap <silent> <S-j> :tabp <cr>
nnoremap <silent> <C-k> <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <silent> <C-j> <cmd>lua vim.diagnostic.goto_prev()<CR>
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

" LSP navigation
nnoremap <silent> <leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>d <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <leader>gs <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>gr <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> lds <cmd>lua vim.lsp.buf.document_symbol()<CR>
"nnoremap <silent> lws <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Plugins
call plug#begin('~/.nvim/plugged')
  " Formatting
  Plug 'editorconfig/editorconfig-vim'

  " Utilities
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'

  " Fuzzy finding
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>

  " Syntax Highlighting
  " Plug 'pangloss/vim-javascript'
  " Plug 'MaxMEllon/vim-jsx-pretty'
  " Plug 'peitalin/vim-jsx-typescript'
  " Plug 'leafgarland/typescript-vim'
  " Plug 'hashivim/vim-terraform'
  " Plug 'jparise/vim-graphql'
  " Plug 'lepture/vim-velocity'

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
  Plug 'bluz71/vim-moonfly-colors'

  " Language Server
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'

  " Rust Analyzer
  Plug 'simrat39/rust-tools.nvim'
call plug#end()

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

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

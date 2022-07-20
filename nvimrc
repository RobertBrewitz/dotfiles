nnoremap ; :
set nobackup
set nohlsearch

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
set directory=.,~/.vim/tmp,~/tmp,/var/tmp,/tmp
" - 'display' defaults to "lastline,msgsep"
" DONE - 'encoding' is UTF-8 (cf. 'fileencoding' for file-content encoding)
" KEEP FOR NOW - 'fillchars' defaults (in effect) to "vert:│,fold:·,sep:│"
" KEEP FOR NOW - 'formatoptions' defaults to "tcqj"
" DONE - 'fsync' is disabled
set fsync
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
set listchars=tab:▸\ ,eol:¬,trail:·
" DONE - 'nrformats' defaults to "bin,hex"
" DONE - 'ruler' is enabled
" DONE - 'sessionoptions' includes "unix,slash", excludes "options"
" DONE - 'shortmess' includes "F", excludes "S"
set shortmess+=cS
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
set undodir=$HOME/.vim/tmp/undo
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

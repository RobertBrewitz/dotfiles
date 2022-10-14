local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap
local vmap = Remap.vmap
local imap = Remap.imap

vim.opt.secure = true
vim.opt.fileformat = "unix"
vim.opt.exrc = true
vim.opt.errorbells = false
vim.opt.fsync = true
vim.opt.directory = ".,~/.nvim/tmp,~/tmp,/var/tmp,/tmp"

-- undo/backup/swap
vim.opt.writebackup = false
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/tmp/undo"

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- completion
vim.opt.completeopt = "menuone,noinsert,noselect"

-- formatting
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.wrap = false
vim.opt.startofline = false

-- presentation
vim.opt.guicursor = ""
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = "tab:▸ ,eol:¬,trail:·"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showtabline = 2
vim.opt.statusline = "%F"
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 1
vim.opt.shortmess:append("c")
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.colorcolumn = "80"

-- timeouts
vim.opt.showcmd = true
vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.updatetime = 300

-- Clipboard
-- vim.opt.clipboard:append("unnamedplus")
vmap("<C-c>", "\"+y<ESC>")
vmap("<C-x>", "\"+c<ESC>")
imap("<C-v>", "<ESC>\"+pa")

-- leader and prevent cursor movement when used
nnoremap("<SPACE>", "<Nop>")
vim.g.mapleader = " "

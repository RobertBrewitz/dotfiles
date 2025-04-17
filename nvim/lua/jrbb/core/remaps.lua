local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
local vmap = Remap.vmap
local imap = Remap.imap

nnoremap(";", ":")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-c>", "<ESC>")
nnoremap("Y", "y$")
nnoremap("<S-k>", ":tabn <cr>", { silent = true, desc = "tabn" })
nnoremap("<S-j>", ":tabp <cr>", { silent = true, desc = "tabp" })
inoremap(",", ",<c-g>u")
inoremap(".", ".<c-g>u")
inoremap("!", "!<c-g>u")
inoremap("?", "?<c-g>u")
nnoremap("<leader>k", ":cnext <cr>", { silent = true, desc = "cnext" })
nnoremap("<leader>j", ":cprev <cr>", { silent = true, desc = "cprev" })
nnoremap("-", "g_", { silent = true })

-- Clipboard
-- vim.opt.clipboard:append("unnamedplus")
vmap("<C-c>", '"+y<ESC>')
vmap("<C-x>", '"+c<ESC>')
imap("<C-v>", '<ESC>"+pa')

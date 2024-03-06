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
nnoremap("<C-c>", "<Esc>")
nnoremap("Y", "y$")
nnoremap("<S-k>", ":tabn <cr>", { silent = true })
nnoremap("<S-j>", ":tabp <cr>", { silent = true })
inoremap(",", ",<c-g>u")
inoremap(".", ".<c-g>u")
inoremap("!", "!<c-g>u")
inoremap("?", "?<c-g>u")
nnoremap("<leader>f", "vi{hzf")
nnoremap("<leader>k", ":cnext <cr>", { silent = true })
nnoremap("<leader>j", ":cprev <cr>", { silent = true })
nnoremap("<leader>e", ":Ex <cr>", { silent = true })

-- Clipboard
-- vim.opt.clipboard:append("unnamedplus")
vmap("<C-c>", '"+y<ESC>')
vmap("<C-x>", '"+c<ESC>')
imap("<C-v>", '<ESC>"+pa')

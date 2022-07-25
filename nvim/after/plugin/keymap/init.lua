local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local nmap = Remap.nmap

nnoremap(";", ":")
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("Y", "y$")
nnoremap("<S-k>", ":tabn <cr>", { silent = true })
nnoremap("<S-j>", ":tabp <cr>", { silent = true })
inoremap(",", ",<c-g>u")
inoremap(".", ".<c-g>u")
inoremap("!", "!<c-g>u")
inoremap("?", "?<c-g>u")
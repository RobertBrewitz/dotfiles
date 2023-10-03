local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<c-p>", ":Files<cr>")
nnoremap("<leader>p", ":Buffers<cr>")

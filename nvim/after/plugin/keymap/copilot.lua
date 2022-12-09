local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<leader>cp", ":Copilot panel<cr>")
nnoremap("<leader>cs", ":Copilot status<cr>")

local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<C-p>", function()
  require('telescope.builtin').git_files()
end)
nnoremap("<leader>pf", function()
  require('telescope.builtin').find_files()
end)
nnoremap("<leader>pb", function()
  require('telescope.builtin').buffers()
end)

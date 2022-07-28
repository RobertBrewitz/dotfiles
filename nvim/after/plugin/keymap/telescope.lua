local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap
local actions = require("telescope.actions")

require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
      },
      n = {
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<Tab>"] = actions.toggle_selection + actions.move_selection_better,
      }
    },
  }
}

nnoremap("<S-Tab>", function ()
  require('telescope.builtin').prev()
end)
nnoremap("<Tab>", function ()
  require('telescope.builtin').next()
end)
nnoremap("<C-p>", function()
  require('telescope.builtin').git_files()
end)
nnoremap("<leader>pf", function()
  require('telescope.builtin').find_files()
end)
nnoremap("<leader>pb", function()
  require('telescope.builtin').buffers()
end)

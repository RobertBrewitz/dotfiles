return {
  "junegunn/fzf.vim",
  dependencies = "junegunn/fzf",
  config = function()
    local Remap = require("jrbb.keymap")
    local nnoremap = Remap.nnoremap

    nnoremap("<c-p>", ":Files<cr>")
    nnoremap("<leader>p", ":Files<cr>")
  end,
}

return {
  "github/copilot.vim",
  config = function()
    local Remap = require("jrbb.keymap")
    local nnoremap = Remap.nnoremap

    nnoremap("<leader>cp", ":Copilot panel<cr>", { desc = "Copilot panel" })
    nnoremap("<leader>cs", ":Copilot status<cr>", { desc = "Copilot status" })
    nnoremap("<leader>cd", ":Copilot disable<cr>", { desc = "Copilot disable" })
    nnoremap("<leader>ce", ":Copilot enable<cr>", { desc = "Copilot enable" })
  end,
}

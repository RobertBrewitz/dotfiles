return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local Remap = require("jrbb.keymap")
      local nnoremap = Remap.nnoremap

      nnoremap("<leader>gd", function() vim.lsp.buf.definition() end)
      nnoremap("<leader>d", function() vim.lsp.buf.hover() end)
      nnoremap("<leader>gi", function() vim.lsp.buf.implementation() end)
      nnoremap("<leader>gs", function() vim.lsp.buf.signature_help() end)
      nnoremap("<leader>gy", function() vim.lsp.buf.type_definition() end)
      nnoremap("<leader>gr", function() vim.lsp.buf.references() end)
      nnoremap("<leader>rn", function() vim.lsp.buf.rename() end)
    end,
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local Remap = require("jrbb.keymap")
      local nnoremap = Remap.nnoremap

      local function config(_config)
        return vim.tbl_deep_extend("force", {
          capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        }, _config or {})
      end

      --require("lspconfig").rust_analyzer.setup({
      --  cmd = { "rustup", "run", "stable", "rust-analyzer" },
      --});

      require("lspconfig").tsserver.setup(config());

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

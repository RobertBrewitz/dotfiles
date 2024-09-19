return {
  {
    "typescript-language-server/typescript-language-server",
    dependencies = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    opts = function()
      return {
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      }
    end,
    config = function(_, opts)
      require("lspconfig").ts_ls.setup(opts)
    end,
  },
}

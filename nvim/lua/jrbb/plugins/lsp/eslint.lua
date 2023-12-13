return {
  {
    'mantoni/eslint_d.js',
    dependencies = { 'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp' },
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    opts = function()
      return {
        capabilities = require('cmp_nvim_lsp').default_capabilities(
          vim.lsp.protocol.make_client_capabilities()
        ),
      }
    end,
    config = function(_, opts)
      require('lspconfig').eslint.setup(opts)
    end,
  }
}

return {
  {
    'wgsl-analyzer/wgsl-analyzer',
    dependencies = { 'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp' },
    ft = 'wgsl',
    opts = function()
      return {
        capabilities = require("cmp_nvim_lsp").default_capabilities(
          vim.lsp.protocol.make_client_capabilities()
        ),
      };
    end,
    config = function(_, opts)
      require('lspconfig').wgsl_analyzer.setup(opts);
    end,
  }
}

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "tsserver",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
}

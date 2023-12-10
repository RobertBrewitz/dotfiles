return {
  {
    "williamboman/mason.nvim",
    opts = function()
      return {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      };
    end,
    config = function(_, opts)
      require("mason").setup(opts);
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function()
      return {
        ensure_installed = {
          "rust_analyzer",
          "tsserver",
          "wgsl_analyzer",
        },
      };
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup(opts);
    end,
  },
}

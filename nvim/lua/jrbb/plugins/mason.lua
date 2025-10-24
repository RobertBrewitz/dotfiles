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
      }
    end,
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function()
      return {
        ensure_installed = {
          "eslint_d",
          "prettier",
        },
      }
    end,
    config = function(_, opts)
      require("mason-tool-installer").setup(opts)
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = function()
      return {
        ensure_installed = {
          "ts_ls",
          "lua_ls",
          "eslint",
        },
      }
    end,
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },
}

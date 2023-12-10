return {
  {
    'simrat39/rust-tools.nvim',
    dependencies = { 'neovim/nvim-lspconfig', 'hrsh7th/cmp-nvim-lsp' },
    ft = { 'rust' },
    opts = function()
      local rust_tools = require("rust-tools")
      local mason_registry = require("mason-registry")

      local codelldb = mason_registry.get_package("codelldb")
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

      return {
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          ),
          on_attach = function(_, bufnr)
            local Remap = require("jrbb.keymap")
            local nmap = Remap.nmap

            nmap("<leader>bg", rust_tools.hover_actions.hover_actions, { buffer = bufnr })
            nmap("<leader>ba", rust_tools.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
      }
    end,
    config = function(_, opts)
      require('rust-tools').setup(opts)
    end,
  },
  {
    'saecki/crates.nvim',
    dependencies = "hrsh7th/nvim-cmp",
    ft = { 'rust', 'toml' },
    opts = function()
      return {
        text = {
          loading = " ⏳ Loading",
          version = " 🟢 %s",
          prerelease = " prerelease %s",
          yanked = " error %s",
          nomatch = " No match",
          upgrade = " 🟡 %s",
          error = " Error fetching crate",
        }
      }
    end,
    config = function(_, opts)
      require("crates").setup(opts)
    end,
  }
}

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
      local Remap = require("jrbb.keymap")
      local nnoremap = Remap.nnoremap
      local vnoremap = Remap.vnoremap
      local inoremap = Remap.inoremap
      local xnoremap = Remap.xnoremap
      local vmap = Remap.vmap
      local imap = Remap.imap
      local nmap = Remap.nmap

      local crates = require('crates')
      local keymapOpts = { silent = true }

      nmap('<leader>ct', crates.toggle, keymapOpts)
      nmap('<leader>cr', crates.reload, keymapOpts)
      nmap('<leader>cv', crates.show_versions_popup, keymapOpts)
      nmap('<leader>cf', crates.show_features_popup, keymapOpts)
      nmap('<leader>cd', crates.show_dependencies_popup, keymapOpts)
      nmap('<leader>cu', crates.update_crate, keymapOpts)
      vmap('<leader>cu', crates.update_crates, keymapOpts)
      nmap('<leader>ca', crates.update_all_crates, keymapOpts)
      nmap('<leader>cU', crates.upgrade_crate, keymapOpts)
      vmap('<leader>cU', crates.upgrade_crates, keymapOpts)
      nmap('<leader>cA', crates.upgrade_all_crates, keymapOpts)
      nmap('<leader>ce', crates.expand_plain_crate_to_inline_table, keymapOpts)
      nmap('<leader>cE', crates.extract_crate_into_table, keymapOpts)
      nmap('<leader>cH', crates.open_homepage, keymapOpts)
      nmap('<leader>cR', crates.open_repository, keymapOpts)
      nmap('<leader>cD', crates.open_documentation, keymapOpts)
      nmap('<leader>cC', crates.open_crates_io, keymapOpts)

      return {
        text = {
          loading = " ⏳ Loading",
          version = " 🟢 %s",
          prerelease = " prerelease %s",
          yanked = " error %s",
          nomatch = " No match",
          upgrade = " 🟡 %s",
          error = " Error fetching crate",
        },
        popup = {
          text = {
            title = " %s",
            pill_left = ">",
            pill_right = "<",
            description = "%s",
            created_label = "created        ",
            created = "%s",
            updated_label = "updated        ",
            updated = "%s",
            downloads_label = "downloads      ",
            downloads = "%s",
            homepage_label = "homepage       ",
            homepage = "%s",
            repository_label = "repository     ",
            repository = "%s",
            documentation_label = " documentation  ",
            documentation = "%s",
            crates_io_label = " crates.io      ",
            crates_io = "%s",
            categories_label = "categories     ",
            keywords_label = "keywords       ",
            version = "  %s",
            prerelease = "%s",
            yanked = "%s",
            version_date = "  %s",
            feature = "  %s",
            enabled = "%s",
            transitive = "%s",
            normal_dependencies_title = "Dependencies",
            build_dependencies_title = "Build dependencies",
            dev_dependencies_title = "Dev dependencies",
            dependency = "  %s",
            optional = "%s",
            dependency_version = "  %s",
            loading = " ⏳ Loading",
          },
          keys = {
            hide = { "q", "<esc>" },
            open_url = { "<cr>" },
            select = { "<cr>" },
            select_alt = { "s" },
            toggle_feature = { "<cr>" },
            copy_value = { "yy" },
            goto_item = { "gd", "K", "<C-LeftMouse>" },
            jump_forward = { "<c-i>" },
            jump_back = { "<c-o>", "<C-RightMouse>" },
          },
        },
      }
    end,
    config = function(_, opts)
      require("crates").setup(opts)
    end,
  }
}

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          vim.lsp.inlay_hint.enable(false)
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
  {
    "saecki/crates.nvim",
    dependencies = "hrsh7th/nvim-cmp",
    ft = { "rust", "toml" },
    tag = "stable",
    opts = function()
      local Remap = require("jrbb.keymap")
      local vmap = Remap.vmap
      local nmap = Remap.nmap

      local crates = require("crates")
      local keymapOpts = { silent = true }

      nmap("<leader>ct", crates.toggle, keymapOpts)
      nmap("<leader>cr", crates.reload, keymapOpts)
      nmap("<leader>cv", crates.show_versions_popup, keymapOpts)
      nmap("<leader>cf", crates.show_features_popup, keymapOpts)
      nmap("<leader>cd", crates.show_dependencies_popup, keymapOpts)
      nmap("<leader>cu", crates.update_crate, keymapOpts)
      vmap("<leader>cu", crates.update_crates, keymapOpts)
      nmap("<leader>ca", crates.update_all_crates, keymapOpts)
      nmap("<leader>cU", crates.upgrade_crate, keymapOpts)
      vmap("<leader>cU", crates.upgrade_crates, keymapOpts)
      nmap("<leader>cA", crates.upgrade_all_crates, keymapOpts)
      nmap("<leader>ce", crates.expand_plain_crate_to_inline_table, keymapOpts)
      nmap("<leader>cE", crates.extract_crate_into_table, keymapOpts)
      nmap("<leader>cH", crates.open_homepage, keymapOpts)
      nmap("<leader>cR", crates.open_repository, keymapOpts)
      nmap("<leader>cD", crates.open_documentation, keymapOpts)
      nmap("<leader>cC", crates.open_crates_io, keymapOpts)

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
            hide = { "q" },
            open_url = { "<cr>" },
            select = { "<cr>" },
            select_alt = { "s" },
            toggle_feature = { "<cr>" },
            copy_value = { "yy" },
            goto_item = { "gd" },
            jump_forward = { "<c-i>" },
            jump_back = { "<c-o>" },
          },
        },
      }
    end,
    config = function(_, opts)
      require("crates").setup(opts)
    end,
  },
}

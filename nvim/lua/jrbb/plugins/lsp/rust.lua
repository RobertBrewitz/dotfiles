return {
  --{
  --  "mrcjkb/rustaceanvim",
  --  version = "^5.13.0",
  --  ft = { "rust" },
  --  opts = {
  --    server = {
  --      on_attach = function(client, bufnr)
  --        vim.lsp.inlay_hint.enable(false)
  --      end,
  --      default_settings = {
  --        -- rust-analyzer language server configuration
  --        ["rust-analyzer"] = {
  --          cargo = {
  --            target = "x86_64-unknown-linux-gnu",
  --            buildScripts = {
  --              enable = true,
  --            },
  --          },
  --          checkOnSave = true,
  --          check = {
  --            allTargets = true,
  --            command = "clippy",
  --            extraArgs = { "--no-deps" },
  --          },
  --          procMacro = {
  --            enable = true,
  --          },
  --        },
  --      },
  --    },
  --  },
  --  config = function(_, opts)
  --    local rustacean = require("rustaceanvim")
  --    local Remap = require("jrbb.keymap")
  --    local nnoremap = Remap.nnoremap
  --    local rust_target = "x86_64-unknown-linux-gnu"

  --    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})

  --    function change_rust_analyzer_target(new_target)
  --        -- Get the LSP client attached to the current buffer
  --        local clients = vim.lsp.buf_get_clients(0)
  --        local rust_analyzer = nil
  --        for _, client in pairs(clients) do
  --          if client.name == 'rust-analyzer' then
  --            rust_analyzer = client
  --            break
  --          end
  --        end
  --        if rust_analyzer == nil then
  --          print('rust-analyzer is not attached to this buffer')
  --          return
  --        end

  --        -- Build the new settings for rust-analyzer
  --        local new_settings = {
  --          ['rust-analyzer'] = {
  --            cargo = {
  --              target = new_target,
  --            },
  --          },
  --        }

  --        -- Send a notification to rust-analyzer to update its settings
  --        rust_analyzer.notify('workspace/didChangeConfiguration', {
  --          settings = new_settings,
  --        })

  --        print('rust-analyzer cargo target set to: ' .. new_target)
  --      end

  --    function ToggleRustTarget()
  --      if rust_target == "x86_64-unknown-linux-gnu" then
  --        rust_target = "wasm32-unknown-unknown"
  --      else
  --        rust_target = "x86_64-unknown-linux-gnu"
  --      end

  --      --require('lspconfig').rust_analyzer.setup({
  --      --  settings = {
  --      --    ["rust-analyzer"] = {
  --      --      cargo = {
  --      --        target = rust_target,
  --      --      },
  --      --    },
  --      --  },
  --      --})

  --      change_rust_analyzer_target(rust_target)

  --      vim.cmd('LspRestart rust_analyzer')
  --      --print("Switched rust-analyzer target to " .. rust_target)
  --    end

  --    nnoremap("<leader>rt", ToggleRustTarget)
  --  end,
  --},
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
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
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

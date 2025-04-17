return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = function()
      return {
        capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      }
    end,
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local rust_target = "x86_64-unknown-linux-gnu"
      local Remap = require("jrbb.keymap")
      local nmap = Remap.nmap
      local nnoremap = Remap.nnoremap

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
        border = "single",
      })

      lspconfig.gopls.setup(opts)
      lspconfig.wgsl_analyzer.setup(opts)
      lspconfig.ts_ls.setup(opts)
      lspconfig.lua_ls.setup({
        capabilities = opts.capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      lspconfig.rust_analyzer.setup({
        capabilities = opts.capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              buildScripts = {
                enable = true,
              },
              features = "all",
            },
            checkOnSave = true,
            check = {
              allTargets = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
            },
          },
        },
      })

      function ToggleRustTarget()
        if rust_target == "x86_64-unknown-linux-gnu" then
          rust_target = "wasm32-unknown-unknown"
        else
          rust_target = "x86_64-unknown-linux-gnu"
        end

        require('lspconfig').rust_analyzer.setup({
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                target = rust_target,
              },
            },
          },
        })

        vim.cmd('LspRestart')
        print("Switched rust-analyzer target to " .. rust_target)
      end

      nnoremap("<leader>rt", ToggleRustTarget, { desc = "ToggleRustTarget wasm/linux" })

      -- Temporary workaround for 32802 error
      for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
        local default_diagnostic_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context, config)
          if err ~= nil and err.code == -32802 then
            return
          end

          if err ~= nil and err.code == -32603 then
            return
          end

          return default_diagnostic_handler(err, result, context, config)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = "Add workspace folder" })
          nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = "Remove workspace folder" })
          nmap("<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { buffer = ev.buf, desc = "List workspace folders" })
          nmap("<leader>ga", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
          nmap("<leader>d", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover" })
          nmap("<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
          nmap("<leader>gf", function()
            vim.lsp.buf.format({ async = true })
          end, { buffer = ev.buf, desc = "Format" })
        end,
      })
    end,
  },
}

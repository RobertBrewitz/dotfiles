return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    opts = function()
      return {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      }
    end,
    config = function(_, opts)
      local Remap = require("jrbb.keymap")
      local nmap = Remap.nmap
      local nnoremap = Remap.nnoremap
      local rust_target = "x86_64-unknown-linux-gnu"

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
        border = "single",
      })

      vim.lsp.enable("gopls", opts)
      vim.lsp.enable("wgsl_analyzer", opts)
      vim.lsp.enable("ts_ls", opts)
      vim.lsp.enable("lua_ls", {
        capabilities = opts.capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
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

        vim.lsp.config("rust_analyzer", {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                target = rust_target,
              },
            },
          },
        })

        vim.cmd("LspRestart")
        print("Switched rust-analyzer target to " .. rust_target)
      end

      vim.lsp.enable("rust_analyzer", {
        capabilities = opts.capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              buildScripts = {
                enable = true,
              },
              features = "all",
              target = rust_target,
            },
            -- used for diagnostics
            check = {
              allTargets = true,
              command = "clippy",
              extraArgs = {
                "--no-deps",
              },
              features = "all",
              targets = {
                "x86_64-unknown-linux-gnu",
                "wasm32-unknown-unknown",
                "x86_64-pc-windows-gnu",
              },
            },
            rustfmt = {
              enable = true,
              extraArgs = { "+nightly", "--edition=2024" },
            },
            procMacro = {
              enable = true,
            },
          },
        },
      })

      nnoremap("<leader>rt", ToggleRustTarget, { desc = "ToggleRustTarget wasm/linux" })

      -- Temporary workaround for 32802 error
      for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
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

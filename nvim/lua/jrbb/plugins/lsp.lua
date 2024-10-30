return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local rust_target = "x86_64-unknown-linux-gnu"
      local Remap = require("jrbb.keymap")
      local nmap = Remap.nmap
      local vmap = Remap.vmap
      local nnoremap = Remap.nnoremap

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
        border = "single",
      })

      lspconfig.gopls.setup({})
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      lspconfig.rust_analyzer.setup({
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              target = "x86_64-unknown-linux-gnu",
              buildScripts = {
                enable = true,
              },
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

      nnoremap("<leader>rt", ToggleRustTarget)


      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local opts = { buffer = ev.buf }

          nmap("<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          nmap("<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          nmap("<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)

          nmap("<leader>la", function()
            vim.lsp.buf.code_action()
          end, opts)
          vmap("<leader>la", function()
            vim.lsp.buf.code_action()
          end, opts)
          nmap("<leader>d", function()
            vim.lsp.buf.hover()
          end, opts)

          nmap("<leader>gd", function()
            vim.lsp.buf.definition()
          end, opts)
          nmap("<leader>li", function()
            vim.lsp.buf.implementation()
          end, opts)
          nmap("<leader>lsh", function()
            vim.lsp.buf.signature_help()
          end, opts)
          nmap("<leader>ltd", function()
            vim.lsp.buf.type_definition()
          end, opts)
          nmap("<leader>lr", function()
            vim.lsp.buf.references()
          end, opts)
          nmap("<leader>ld", function()
            vim.lsp.buf.declaration()
          end, opts)

          nmap("<leader>rn", function()
            vim.lsp.buf.rename()
          end, opts)
          nmap("<space>lf", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end,
  },
}

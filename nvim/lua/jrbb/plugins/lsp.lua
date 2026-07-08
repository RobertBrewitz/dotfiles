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

      vim.lsp.config("gopls", {
        capabilities = opts.capabilities,
        settings = {
          gopls = {
            ["ui.inlayhint.hints"] = {
              assignVariableTypes = false,
              compositeLiteralFields = true,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              ignoredError = false,
              parameterNames = true,
              rangeVariableTypes = false,
            },
          },
        },
      })
      vim.lsp.enable("gopls")

      -- NOTE: WGSL wgsl_analyzer does not provide inlay hints, garbage
      -- vim.lsp.enable("wgsl_analyzer", {
      --   filetypes = { "wgsl", "wesl" },
      --   capabilities = opts.capabilities,
      -- })
      --
      -- vim.lsp.handlers["wgsl-analyzer/requestConfiguration"] = function(err, result, ctx, config)
      --   return {
      --     success = true,
      --     customImports = { _dummy_ = "dummy" },
      --     shaderDefs = {},
      --     trace = {
      --       extension = false,
      --       server = false,
      --     },
      --     inlayHints = {
      --       enabled = false,
      --       typeHints = false,
      --       parameterHints = false,
      --       structLayoutHints = false,
      --       typeVerbosity = "inner",
      --     },
      --     diagnostics = {
      --       typeErrors = true,
      --       nagaParsingErrors = true,
      --       nagaValidationErrors = true,
      --       nagaVersion = "main",
      --     },
      --   }
      -- end

      -- NOTE: Using glasgow wgsl LSP server instead of wgsl_analyzer because it provides inlay hints and better features
      vim.lsp.config("glasgow", { capabilities = opts.capabilities })
      vim.lsp.enable("glasgow")

      vim.lsp.config("ts_ls", {
        capabilities = opts.capabilities,
        settings = {
          javascript = {
            inlayHints = {
              parameterNames = {
                enabled = "literals",
                suppressWhenArgumentMatchesName = true,
              },
              parameterTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              variableTypes = {
                enabled = false,
                suppressWhenTypeMatchesName = true,
              },
            },
          },
          typescript = {
            inlayHints = {
              parameterNames = {
                enabled = "literals",
                suppressWhenArgumentMatchesName = true,
              },
              parameterTypes = { enabled = false },
              propertyDeclarationTypes = { enabled = false },
              functionLikeReturnTypes = { enabled = false },
              variableTypes = {
                enabled = false,
                suppressWhenTypeMatchesName = true,
              },
              enumMemberValues = { enabled = false },
            },
          },
        },
      })
      vim.lsp.enable("ts_ls")

      vim.lsp.config("lua_ls", {
        capabilities = opts.capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            hint = {
              enable = true,
              arrayIndex = "Disable",
              await = false,
              awaitPropagate = false,
              paramName = "Literal",
              paramType = false,
              semicolon = "Disable",
              setType = false,
            },
          },
        },
      })
      vim.lsp.enable("lua_ls")

      if vim.fn.exists(":LspRestart") == 0 then
        vim.api.nvim_create_user_command("LspRestart", function()
          local bufnr = vim.api.nvim_get_current_buf()
          local client_names = {}

          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            client_names[client.name] = true
          end

          vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = bufnr }), true)

          vim.schedule(function()
            for client_name in pairs(client_names) do
              vim.lsp.enable(client_name)
            end

            vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr })
          end)
        end, { desc = "Restart LSP clients for current buffer" })
      end

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
                buildScripts = {
                  enable = true,
                },
                features = "all",
                target = rust_target,
              },
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
              completion = {
                autoimport = {
                  enable = true,
                },
              },
              imports = {
                prefix = "plain",
              },
              hover = {
                maxSubstitutionLength = nil,
                show = {
                  fields = 999,
                  enumVariants = 999,
                  traitAssocItems = 999,
                },
              },
              inlayHints = {
                bindingModeHints = { enable = false },
                chainingHints = { enable = false },
                closingBraceHints = {
                  enable = true,
                  minLines = 5,
                },
                closureCaptureHints = { enable = false },
                closureReturnTypeHints = { enable = "never" },
                expressionAdjustmentHints = { enable = "never" },
                genericParameterHints = {
                  const = { enable = false },
                  lifetime = { enable = false },
                  type = { enable = false },
                },
                lifetimeElisionHints = { enable = "never" },
                parameterHints = {
                  enable = false,
                  missingArguments = { enable = false },
                },
                typeHints = { enable = false },
              },
              procMacro = {
                enable = true,
              },
              rustfmt = {
                enable = true,
                extraArgs = { "+nightly", "--edition=2024" },
              },
            },
          },
        })

        vim.cmd("LspRestart")
        print("Switched rust-analyzer target to " .. rust_target)
      end

      vim.lsp.config("rust_analyzer", {
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
            completion = {
              autoimport = {
                enable = true,
              },
            },
            imports = {
              prefix = "plain",
            },
            hover = {
              maxSubstitutionLength = nil,
              show = {
                fields = 999,
                enumVariants = 999,
                traitAssocItems = 999,
              },
            },
            inlayHints = {
              bindingModeHints = { enable = false },
              chainingHints = { enable = false },
              closingBraceHints = {
                enable = true,
                minLines = 5,
              },
              closureCaptureHints = { enable = false },
              closureReturnTypeHints = { enable = "never" },
              expressionAdjustmentHints = { enable = "never" },
              genericParameterHints = {
                const = { enable = false },
                lifetime = { enable = false },
                type = { enable = false },
              },
              lifetimeElisionHints = { enable = "never" },
              parameterHints = {
                enable = false,
                missingArguments = { enable = false },
              },
              typeHints = { enable = false },
            },
            procMacro = {
              enable = true,
            },
            rustfmt = {
              enable = true,
              extraArgs = { "+nightly", "--edition=2024" },
            },
          },
        },
      })
      vim.lsp.enable("rust_analyzer")

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

      -- Force-stop all LSP clients on exit to prevent orphaned processes
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          vim.lsp.stop_client(vim.lsp.get_clients(), true)
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.wgsl", command = "setfiletype wgsl" })
          vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, { pattern = "*.wesl", command = "setfiletype wesl" })

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client ~= nil and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end

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

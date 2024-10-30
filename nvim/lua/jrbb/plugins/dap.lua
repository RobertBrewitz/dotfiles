return {
  {
    "mfussenegger/nvim-dap",
    config = function(_, opts)
      --local dap = require("dap")
      --local widgets = require("dap.ui.widgets")
      local Remap = require("jrbb.keymap")
      local nnoremap = Remap.nnoremap

      --dap.listeners.after.event_initialized["dapui_config"] = function()
      --  widgets.sidebar(widgets.scopes).open()
      --end

      --dap.listeners.before.event_terminated["dapui_config"] = function()
      --  widgets.sidebar(widgets.scopes).close()
      --end

      --dap.listeners.before.event_exited["dapui_config"] = function()
      --  widgets.sidebar(widgets.scopes).close()
      --end

      nnoremap("<leader>bc", ":DapContinue<cr>", { silent = true })
      nnoremap("<leader>bj", ":DapLoadLaunchJSON<cr>", { silent = true })
      nnoremap("<leader>brf", ":DapRestartFrame<cr>", { silent = true })
      nnoremap("<leader>blv", ":DapSetLogLevel<cr>", { silent = true })
      nnoremap("<leader>bsl", ":DapShowLog<cr>", { silent = true })
      nnoremap("<leader>bsi", ":DapStepInto<cr>", { silent = true })
      nnoremap("<leader>bso", ":DapStepOut<cr>", { silent = true })
      nnoremap("<leader>bsv", ":DapStepOver<cr>", { silent = true })
      nnoremap("<leader>bq", ":DapTerminate<cr>", { silent = true })
      nnoremap("<leader>btb", ":DapToggleBreakpoint<cr>", { silent = true })
      nnoremap("<leader>btr", ":DapToggleRepl<cr>", { silent = true })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    opts = {
      mappings = {
        expand = { "<CR>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      }
    },
    config = function(_, opts)
      require("dapui").setup(opts)
      local Remap = require("jrbb.keymap")
      local nnoremap = Remap.nnoremap
      local dapui = require("dapui")

      nnoremap("<leader>bui", function()
        dapui.open()
      end)
      nnoremap("<leader>bur", function()
        dapui.open({ reset = true })
      end)
      nnoremap("<leader>biu", function()
        dapui.close()
      end)
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
  },
}

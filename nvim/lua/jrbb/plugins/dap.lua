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

      nnoremap("<leader>bc", ":DapContinue<cr>", { silent = true, desc = "DapContinue" })
      nnoremap("<leader>bj", ":DapLoadLaunchJSON<cr>", { silent = true, desc = "DapLoadLaunchJSON" })
      nnoremap("<leader>brf", ":DapRestartFrame<cr>", { silent = true, desc = "DapRestartFrame" })
      nnoremap("<leader>blv", ":DapSetLogLevel<cr>", { silent = true, desc = "DapSetLogLevel" })
      nnoremap("<leader>bsl", ":DapShowLog<cr>", { silent = true, desc = "DapShowLog" })
      nnoremap("<leader>bsi", ":DapStepInto<cr>", { silent = true, desc = "DapStepInto" })
      nnoremap("<leader>bso", ":DapStepOut<cr>", { silent = true, desc = "DapStepOut" })
      nnoremap("<leader>bsv", ":DapStepOver<cr>", { silent = true, desc = "DapStepOver" })
      nnoremap("<leader>bq", ":DapTerminate<cr>", { silent = true, desc = "DapTerminate" })
      nnoremap("<leader>btb", ":DapToggleBreakpoint<cr>", { silent = true, desc = "DapToggleBreakpoint" })
      nnoremap("<leader>btr", ":DapToggleRepl<cr>", { silent = true, desc = "DapToggleRepl" })
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
      end, { desc = "DapUI" })
      nnoremap("<leader>bur", function()
        dapui.open({ reset = true })
      end, { desc = "DapUI Reset" })
      nnoremap("<leader>biu", function()
        dapui.close()
      end, { desc = "DapUI Close" })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
  },
}

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
      --nnoremap("<leader>bj", ":DapLoadLaunchJSON<cr>", { silent = true })
      --nnoremap("<leader>br", ":DapRestartFrame<cr>", { silent = true })
      --nnoremap("<leader>bv", ":DapSetLogLevel<cr>", { silent = true })
      --nnoremap("<leader>bl", ":DapShowLog<cr>", { silent = true })
      --nnoremap("<leader>bi", ":DapStepInto<cr>", { silent = true })
      --nnoremap("<leader>bo", ":DapStepOut<cr>", { silent = true })
      --nnoremap("<leader>bO", ":DapStepOver<cr>", { silent = true })
      --nnoremap("<leader>bt", ":DapTerminate<cr>", { silent = true })
      nnoremap("<leader>bb", ":DapToggleBreakpoint<cr>", { silent = true })
      --nnoremap("<leader>bp", ":DapToggleRepl<cr>", { silent = true })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    opts = {
      --mappings = {
      --  expand = { "<CR>" },
      --  open = "o",
      --  remove = "d",
      --  edit = "e",
      --  repl = "r",
      --  toggle = "t",
      --}
    },
    config = function(_, opts)
      require("dapui").setup(opts)
      local Remap = require("jrbb.keymap")
      local nnoremap = Remap.nnoremap
      local dapui = require("dapui")

      nnoremap("<leader>bui", function() dapui.open() end)
      nnoremap("<leader>bur", function() dapui.open({ reset = true }) end)
      nnoremap("<leader>biu", function() dapui.close() end)
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
  },
}

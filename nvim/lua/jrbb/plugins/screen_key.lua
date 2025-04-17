local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

return {
  {
    "NStefan002/screenkey.nvim",
    lazy = false,
    version = "*",
    opts = function()
      return {
        win_opts = {
            row = vim.o.lines - vim.o.cmdheight - 1,
            col = vim.o.columns - 1,
            relative = "editor",
            anchor = "SE",
            width = 40,
            height = 3,
            border = "single",
            title = "",
            title_pos = "center",
            style = "minimal",
            focusable = false,
            noautocmd = true,
        },
        compress_after = 3,
        clear_after = 3,
        disable = {
            filetypes = {},
            buftypes = {},
            events = false,
        },
        show_leader = true,
        group_mappings = false,
        display_infront = {},
        display_behind = {},
        filter = function(keys)
            return keys
        end,
        keys = {
            ["<TAB>"] = "󰌒",
            ["<CR>"] = "󰌑",
            ["<ESC>"] = "Esc",
            ["<SPACE>"] = "␣",
            ["<BS>"] = "󰌥",
            ["<DEL>"] = "Del",
            ["<LEFT>"] = "",
            ["<RIGHT>"] = "",
            ["<UP>"] = "",
            ["<DOWN>"] = "",
            ["<HOME>"] = "Home",
            ["<END>"] = "End",
            ["<PAGEUP>"] = "PgUp",
            ["<PAGEDOWN>"] = "PgDn",
            ["<INSERT>"] = "Ins",
            ["<F1>"] = "󱊫",
            ["<F2>"] = "󱊬",
            ["<F3>"] = "󱊭",
            ["<F4>"] = "󱊮",
            ["<F5>"] = "󱊯",
            ["<F6>"] = "󱊰",
            ["<F7>"] = "󱊱",
            ["<F8>"] = "󱊲",
            ["<F9>"] = "󱊳",
            ["<F10>"] = "󱊴",
            ["<F11>"] = "󱊵",
            ["<F12>"] = "󱊶",
            ["CTRL"] = "ctrl",
            ["ALT"] = "alt",
            ["SUPER"] = "",
            ["<leader>"] = "<leader>",
        },
      }
    end,
    config = function(_, opts)
      local screenkey = require("screenkey")
      vim.g.screenkey_statusline_component = true

      nnoremap("<leader>sk", function()
        screenkey.toggle()
      end, { desc = "Toggle Screenkey" })

      screenkey.setup(opts)
      screenkey.toggle()
    end,
  },
}

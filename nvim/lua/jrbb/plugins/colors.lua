return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.g.jrbb_colorscheme = "catppuccin-mocha"

      function ApplyColorscheme()
        vim.cmd("colorscheme " .. vim.g.jrbb_colorscheme)
      end

      require("catppuccin").setup({
        transparent_background = true,
        default_integrations = false,
        integrations = {
          gitsigns = true,
          nvimtree = true,
          telescope = {
            enabled = true,
          },
          treesitter = true,
          which_key = true,
          mason = true,
          notify = true,
          copilot_vim = true,
          blink_cmp = {
            style = "bordered",
          },
        },
        custom_highlights = function(colors)
          return {
            WinSeparator = { fg = colors.overlay1 },
            BlinkCmpDocBorder = { fg = colors.blue },
            BlinkCmpKind = { fg = colors.blue },
            BlinkCmpMenu = { fg = colors.text },
            BlinkCmpMenuBorder = { fg = colors.blue, bg = colors.base },
            BlinkCmpSignatureHelpActiveParameter = { fg = colors.mauve },
            BlinkCmpSignatureHelpBorder = { fg = colors.blue },
          }
        end,
        color_overrides = {
          mocha = {
            base = "#000000",
            mantle = "#000000",
            crust = "#000000",
          },
        },
      })

      ApplyColorscheme()
    end,
  },
}

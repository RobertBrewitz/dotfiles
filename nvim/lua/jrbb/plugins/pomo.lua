return {
  "epwalsh/pomo.nvim",
  version = "*",  -- Recommended, use latest release instead of latest commit
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    -- Optional, but highly recommended if you want to use the "Default" timer
    "rcarriga/nvim-notify",
  },
  opts = {
    update_interval = 1000,
    background_color = "#000000",
    notifiers = {
      {
        name = "Default",
        opts = {
          sticky = true,
          title_icon = "󱎫",
          text_icon = "󰄉",
        },
      },
    },
  },
  config = function(_, opts)
    require("pomo").setup(opts)
    require("notify").setup({
      background_colour = opts.background_color,
    })
  end,
}

return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "junegunn/vim-emoji",
        config = function()
          require("jrbb.core.emoji").setup()
        end,
      },
    },
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "emoji" },
        providers = {
          emoji = {
            name = "Emoji",
            module = "blink.cmp.sources.complete_func",
            score_offset = 20,
            max_items = 50,
            opts = {
              complete_func = function()
                return require("jrbb.core.emoji").enabled(0) and "emoji#complete" or nil
              end,
            },
            override = {
              get_trigger_characters = function()
                return { ":" }
              end,
            },
          },
        },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}

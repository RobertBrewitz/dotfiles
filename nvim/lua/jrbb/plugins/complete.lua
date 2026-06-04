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
      completion = {
        documentation = { auto_show = false },
        list = {
          selection = {
            preselect = true,
            auto_insert = function(ctx)
              return not require("jrbb.core.emoji").completing(ctx)
            end,
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          markdown = { inherit_defaults = true, "emoji" },
          text = { inherit_defaults = true, "emoji" },
        },
        providers = {
          emoji = {
            name = "Emoji",
            module = "blink.cmp.sources.complete_func",
            enabled = function()
              return require("jrbb.core.emoji").enabled(0)
            end,
            score_offset = 20,
            max_items = 50,
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                local emoji = item.labelDetails and item.labelDetails.detail
                if emoji and emoji ~= "" then
                  -- Keep the shortcode as the completion label/search text,
                  -- but insert the actual emoji when accepted.
                  item.textEdit.newText = emoji
                end
              end
              return items
            end,
            opts = {
              complete_func = function()
                return "v:lua.require'jrbb.core.emoji'.complete"
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

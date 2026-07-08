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
        documentation = { auto_show = true },
        list = {
          selection = {
            preselect = true,
            auto_insert = function(ctx)
              return not require("jrbb.core.emoji").completing(ctx)
            end,
          },
        },
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_keyword = true,
          show_on_insert = true,
          show_on_accept = true,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = {
          markdown = { inherit_defaults = true, "emoji" },
          text = { inherit_defaults = true, "emoji" },
        },
        providers = {
          lsp = {
            transform_items = function(_, items)
              if vim.bo.filetype ~= "rust" then
                return items
              end

              local qualified_struct_names = {}

              for _, item in ipairs(items) do
                local text
                if item.textEdit and type(item.textEdit.newText) == "string" then
                  text = item.textEdit.newText
                elseif type(item.insertText) == "string" then
                  text = item.insertText
                elseif type(item.label) == "string" then
                  text = item.label
                end

                if type(text) == "string" then
                  local head = text:match("^(.-)%s*{") or text
                  local basename = head:match("([%w_]+)$")
                  if basename ~= nil and text:find("::", 1, true) ~= nil and text:find("{", 1, true) ~= nil then
                    qualified_struct_names[basename] = true
                    item._jrbb_hide_from_menu = true
                  end
                end
              end

              for _, item in ipairs(items) do
                local text
                if item.textEdit and type(item.textEdit.newText) == "string" then
                  text = item.textEdit.newText
                elseif type(item.insertText) == "string" then
                  text = item.insertText
                elseif type(item.label) == "string" then
                  text = item.label
                end

                if type(text) == "string" then
                  local head = text:match("^(.-)%s*{") or text
                  local basename = head:match("([%w_]+)$")

                  if basename ~= nil and qualified_struct_names[basename] == true and item.label == basename then
                    item._jrbb_expand_to_struct_literal = true
                  end

                  if basename ~= nil and basename ~= "" then
                    if item._jrbb_expand_to_struct_literal == true then
                      if item.textEdit and type(item.textEdit.newText) == "string" then
                        item.textEdit.newText = basename .. " { $0 }"
                      elseif type(item.insertText) == "string" then
                        item.insertText = basename .. " { $0 }"
                      end
                      item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet
                    else
                      local struct_head, struct_tail = text:match("^(.-)(%s*{.*)$")
                      if struct_head ~= nil and struct_head ~= "" and struct_tail ~= nil and text:find("[%w_]+:%s*%${%d+:") then
                        if item.textEdit and type(item.textEdit.newText) == "string" then
                          item.textEdit.newText = basename .. " { $0 }"
                        elseif type(item.insertText) == "string" then
                          item.insertText = basename .. " { $0 }"
                        end
                        item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet
                      end
                    end
                  end
                end
              end

              return vim.tbl_filter(function(item)
                return item._jrbb_hide_from_menu ~= true
              end, items)
            end,
            override = {
              resolve = function(source, item, callback)
                local request_item = vim.deepcopy(item)
                request_item._jrbb_expand_to_struct_literal = nil
                return source:resolve(request_item, callback)
              end,
            },
          },
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

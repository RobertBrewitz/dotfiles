return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    local actions = require("telescope.actions")

    local function hidden_picker(extra)
      local picker = {
        hidden = true,
        mappings = {
          i = {
            ["<C-q>"] = actions.send_to_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist,
          },
          n = {
            ["<C-q>"] = actions.send_to_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist,
          },
        },
      }

      for key, value in pairs(extra or {}) do
        picker[key] = value
      end

      return picker
    end

    return {
      pickers = {
        find_files = hidden_picker({
          find_command = { "rg", "--files", "--hidden", "--follow", "--glob", "!.git" },
        }),
        grep_string = hidden_picker(),
        live_grep = hidden_picker(),
        git_files = hidden_picker(),
        lsp_definitions = { hidden = true },
        diagnostics = {
          mappings = {
            i = { ["<CR>"] = actions.select_default },
            n = { ["<CR>"] = actions.select_default },
          },
        },
      },
      defaults = {
        mappings = {
          i = { ["<CR>"] = actions.select_default + actions.center },
          n = { ["<CR>"] = actions.select_default + actions.center },
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "bottom",
          preview_cutoff = 120,
          width = 0.80,
          height = 0.80,
        },
        preview = {
          mime_hook = function(filepath, bufnr, preview_opts)
            local extension = vim.fn.fnamemodify(filepath, ":e"):lower()
            if extension ~= "png" and extension ~= "jpg" then
              require("telescope.previewers.utils").set_preview_message(
                bufnr,
                preview_opts.winid,
                "Binary cannot be previewed"
              )
              return
            end

            local term = vim.api.nvim_open_term(bufnr, {})
            vim.fn.jobstart({ "catimg", filepath }, {
              on_stdout = function(_, data)
                for _, line in ipairs(data) do
                  vim.api.nvim_chan_send(term, line .. "\r\n")
                end
              end,
              stdout_buffered = true,
              pty = true,
            })
          end,
        },
      },
    }
  end,
  config = function(_, opts)
    local builtin = require("telescope.builtin")
    local Remap = require("jrbb.keymap")
    local nnoremap = Remap.nnoremap
    local nmap = Remap.nmap

    local function current_position()
      local win = vim.api.nvim_get_current_win()
      return {
        buf = vim.api.nvim_win_get_buf(win),
        cursor = vim.api.nvim_win_get_cursor(win),
      }
    end

    local function center_after_jump(start, attempts)
      attempts = attempts or 15
      vim.defer_fn(function()
        local current = current_position()
        local unchanged = current.buf == start.buf
          and current.cursor[1] == start.cursor[1]
          and current.cursor[2] == start.cursor[2]

        if unchanged then
          if attempts > 0 then
            center_after_jump(start, attempts - 1)
          end
          return
        end

        if vim.bo[current.buf].buftype == "" then
          vim.cmd("normal! zz")
        end
      end, 25)
    end

    local function centered(fn, fn_opts)
      return function()
        local start = current_position()
        fn(fn_opts)
        center_after_jump(start)
      end
    end

    local type_preview = {}

    local function show_hover()
      vim.lsp.buf.hover({ focus = false })
    end

    local function is_project_location(location, root)
      local uri = location.uri or location.targetUri
      if not uri or not root then
        return false
      end

      local path = vim.fs.normalize(vim.uri_to_fname(uri))
      root = vim.fs.normalize(root)
      path = vim.uv.fs_realpath(path) or path
      root = vim.uv.fs_realpath(root) or root
      return path == root or vim.startswith(path, root .. "/")
    end

    local function show_type_preview(direction)
      local bufnr = vim.api.nvim_get_current_buf()
      local win = vim.api.nvim_get_current_win()
      local cursor = vim.api.nvim_win_get_cursor(win)
      local key = table.concat({ bufnr, vim.b[bufnr].changedtick, cursor[1], cursor[2] }, ":")

      if type_preview.key ~= key then
        type_preview = { key = key, index = 0 }
        if direction > 0 then
          show_hover()
          return
        end
      end

      local function advance()
        local count = #type_preview.locations + 1
        type_preview.index = (type_preview.index + direction) % count

        if type_preview.index == 0 then
          show_hover()
          return
        end

        vim.lsp.util.preview_location(type_preview.locations[type_preview.index], {
          border = "rounded",
          max_height = 40,
          max_width = 120,
          focus = false,
          title = string.format("Type definition %d/%d", type_preview.index, #type_preview.locations),
        })
      end

      if type_preview.locations then
        advance()
        return
      end

      local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/typeDefinition" })
      if vim.tbl_isempty(clients) then
        type_preview.locations = {}
        show_hover()
        return
      end

      local state = type_preview
      vim.lsp.buf_request_all(bufnr, "textDocument/typeDefinition", function(client)
        return vim.lsp.util.make_position_params(win, client.offset_encoding)
      end, function(results)
        if type_preview ~= state then
          return
        end

        state.locations = {}
        for client_id, response in vim.spairs(results) do
          local client = vim.lsp.get_client_by_id(client_id)
          local result = not response.err and response.result or nil
          for _, location in ipairs(result and (vim.islist(result) and result or { result }) or {}) do
            if is_project_location(location, client and client.root_dir) then
              table.insert(state.locations, location)
            end
          end
        end

        advance()
      end)
    end

    local function tab_jump(fn)
      return centered(function()
        vim.cmd("tab split")
        if type(_G.ToggleNvimTree) == "function" then
          _G.ToggleNvimTree()
          vim.cmd("wincmd p")
        end
        fn()
      end)
    end

    nnoremap("<c-p>", builtin.find_files, { desc = "Find Files" })
    nnoremap("<leader>p", builtin.git_files, { desc = "Find Git Files" })
    nnoremap("<c-f>", builtin.live_grep, { desc = "Live Grep" })
    nnoremap("<leader>f", builtin.grep_string, { desc = "Grep String" })

    nmap("<leader>d", function()
      show_type_preview(1)
    end, { desc = "Next LSP Type Definition Preview" })
    nmap("<leader>s", function()
      show_type_preview(-1)
    end, { desc = "Previous LSP Type Definition Preview" })

    nmap("<leader>gd", centered(builtin.lsp_definitions), { desc = "LSP Definitions" })
    nmap("<leader>gD", tab_jump(vim.lsp.buf.definition), { desc = "LSP Definitions in Tab" })
    nmap("<leader>gi", centered(builtin.lsp_implementations), { desc = "LSP Implementations" })
    nmap("<leader>gI", tab_jump(vim.lsp.buf.implementation), { desc = "LSP Implementations in Tab" })
    nmap("<leader>gr", centered(builtin.lsp_references), { desc = "LSP References" })

    nmap("<leader>gg", function()
      builtin.diagnostics({ severity = vim.diagnostic.severity.ERROR })
    end, { desc = "LSP Diagnostics (errors)" })
    nmap("<leader>gG", builtin.diagnostics, { desc = "LSP Diagnostics (all)" })

    require("telescope").setup(opts)
  end,
}

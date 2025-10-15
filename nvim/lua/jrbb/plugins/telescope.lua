return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    local actions = require("telescope.actions")

    return {
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--follow", "--glob", "!.git" },
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
        },
        grep_string = {
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
        },
        live_grep = {
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
        },
        git_files = {
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
        },
        lsp_definitions = {
          hidden = true,
        },
      },
      defaults = {
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
          mime_hook = function(filepath, bufnr, opts)
            local is_image = function(fp)
              local image_extensions = { "png", "jpg" } -- Supported image formats
              local split_path = vim.split(fp:lower(), ".", { plain = true })
              local extension = split_path[#split_path]
              return vim.tbl_contains(image_extensions, extension)
            end
            if is_image(filepath) then
              local term = vim.api.nvim_open_term(bufnr, {})
              local function send_output(_, data, _)
                for _, d in ipairs(data) do
                  vim.api.nvim_chan_send(term, d .. "\r\n")
                end
              end
              vim.fn.jobstart({
                "catimg",
                filepath, -- Terminal image viewer command
              }, { on_stdout = send_output, stdout_buffered = true, pty = true })
            else
              require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
            end
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
    local telescope = require("telescope")

    -- Telescope
    nnoremap("<c-p>", builtin.find_files, { desc = "Find Files" })
    nnoremap("<leader>p", builtin.git_files, { desc = "Find Git Files" })
    nnoremap("<c-f>", builtin.live_grep, { desc = "Live Grep" })
    nnoremap("<leader>f", builtin.grep_string, { desc = "Grep String" })

    -- LSP
    nmap("<leader>gd", builtin.lsp_definitions, { desc = "LSP Definitions" })
    nmap("<leader>gD", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", { desc = "LSP Definitions in Tab" })
    nmap("<leader>gi", builtin.lsp_implementations, { desc = "LSP Implementations" })
    nmap("<leader>gI", "<cmd>tab split | lua vim.lsp.buf.implementation()<CR>", { desc = "LSP Implementations in Tab" })
    nmap("<leader>gt", builtin.lsp_type_definitions, { desc = "LSP Type Definitions" })
    nmap(
      "<leader>gT",
      "<cmd>tab split | lua vim.lsp.buf.type_definition()<CR>",
      { desc = "LSP Type Definitions in Tab" }
    )
    nmap("<leader>gr", builtin.lsp_references, { desc = "LSP References" })
    nmap("<leader>gR", "<cmd>tab split | lua vim.lsp.buf.references()<CR>", { desc = "LSP References in Tab" })
    nmap("<leader>gci", builtin.lsp_incoming_calls, { desc = "LSP Incoming Calls" })
    nmap("<leader>gcI", "<cmd>tab split | lua vim.lsp.buf.incoming_calls()<CR>", { desc = "LSP Incoming Calls in Tab" })
    nmap("<leader>gco", builtin.lsp_outgoing_calls, { desc = "LSP Outgoing Calls" })
    nmap("<leader>gcO", "<cmd>tab split | lua vim.lsp.buf.outgoing_calls()<CR>", { desc = "LSP Outgoing Calls in Tab" })

    nmap("<leader>gs", builtin.lsp_document_symbols, { desc = "LSP Document Symbols" })
    nmap("<leader>gS", builtin.lsp_workspace_symbols, { desc = "LSP Workspace Symbols" })
    nmap("<leader>gy", builtin.lsp_dynamic_workspace_symbols, { desc = "LSP Dynamic Workspace Symbols" })

    nmap("<leader>gg", builtin.diagnostics, { desc = "LSP Diagnostics" })

    telescope.setup(opts)
  end,
}

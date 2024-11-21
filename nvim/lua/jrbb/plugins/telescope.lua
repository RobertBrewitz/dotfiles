return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')
    local Remap = require("jrbb.keymap")
    local nnoremap = Remap.nnoremap
    local nmap = Remap.nmap

    --builtin.find_files({ find_command = { 'fzf' }})

    nnoremap("<c-p>", builtin.find_files)
    nnoremap("<leader>p", builtin.live_grep)

    nmap("<leader>gd", builtin.lsp_definitions)
    nmap("<leader>gi", builtin.lsp_implementations)
    nmap("<leader>gt", builtin.lsp_type_definitions)

    nmap("<leader>gr", builtin.lsp_references)
    nmap("<leader>gs", builtin.lsp_document_symbols)
    nmap("<leader>gS", builtin.lsp_workspace_symbols)
    nmap("<leader>gy", builtin.lsp_dynamic_workspace_symbols)
    nmap("<leader>gc", builtin.lsp_incoming_calls)
    nmap("<leader>gC", builtin.lsp_outgoing_calls)

    nmap("<leader>gg", builtin.diagnostics)
  end
}

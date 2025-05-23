-- local Remap = require("jrbb.keymap")
-- local nnoremap = Remap.nnoremap
--
-- -- netrw
-- vim.g.netrw_banner = 0
-- vim.g.netrw_browse_split = 4
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_winsize = 25
--
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     if vim.fn.argc() == 0 then
--       ToggleNetrw()
--       vim.cmd('wincmd p')
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd({ "BufReadPost" }, {
--   callback = function()
--     if vim.fn.argc() == 0 then
--       local ft = vim.api.nvim_buf_get_option(0, "filetype")
--
--       if ft == "netrw" then
--         return
--       end
--
--       ToggleNetrw()
--       -- vim.cmd('NvimTreeFindFile')
--       vim.cmd('wincmd p')
--     end
--   end,
-- })
--
-- function ToggleNetrw()
--   local netrw_win = nil
--   for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
--     local buf = vim.api.nvim_win_get_buf(win)
--     local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
--     if ft == 'netrw' then
--       netrw_win = win
--       break
--     end
--   end
--
--   if not netrw_win then
--     vim.cmd('Lexplore')
--   else
--     if vim.api.nvim_get_current_win() == netrw_win then
--       vim.cmd('wincmd p')
--     else
--       vim.api.nvim_set_current_win(netrw_win)
--     end
--   end
-- end
--
-- nnoremap("<leader>e", ToggleNetrw, { desc = "ToggleNetrw", silent = true })

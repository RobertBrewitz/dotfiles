return {
    'dense-analysis/ale',
    config = function()
        local g = vim.g

        g.ale_linters = {
            lua = {'lua_language_server'},
            javascript = {'eslint_d'},
        }
    end
}

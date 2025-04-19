local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

return {
  {
    "github/copilot.vim",
    config = function()
      nnoremap("<leader>cp", ":Copilot panel<cr>", { desc = "Copilot panel" })
      nnoremap("<leader>cs", ":Copilot status<cr>", { desc = "Copilot status" })
      nnoremap("<leader>cd", ":Copilot disable<cr>", { desc = "Copilot disable" })
      nnoremap("<leader>ce", ":Copilot enable<cr>", { desc = "Copilot enable" })
    end,
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "v1.0.0",
  --   event = "VeryLazy",
  --   opts = function()
  --     return {
  --       window = {
  --         position = "right",
  --         width = 50,
  --         height = 20,
  --         border = "rounded",
  --       },
  --       question_header = "## User ",
  --       answer_header = "## Copilot ",
  --       error_header = "## Error ",
  --       prompts = {
  --         -- Code related prompts
  --         Explain = "Please explain how the following code works.",
  --         Review = "Please review the following code and provide suggestions for improvement.",
  --         Tests = "Please explain how the selected code works, then generate unit tests for it.",
  --         Refactor = "Please refactor the following code to improve its clarity and readability.",
  --         FixCode = "Please fix the following code to make it work as intended.",
  --         FixError = "Please explain the error in the following text and provide a solution.",
  --         BetterNamings = "Please provide better names for the following variables and functions.",
  --         Documentation = "Please provide documentation for the following code.",
  --         SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
  --         SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
  --         -- Text related prompts
  --         Summarize = "Please summarize the following text.",
  --         Spelling = "Please correct any grammar and spelling errors in the following text.",
  --         Wording = "Please improve the grammar and wording of the following text.",
  --         Concise = "Please rewrite the following text to make it more concise.",
  --       },
  --     }
  --   end,
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")
  --     chat.setup(opts)
  --   end,
  -- },
}

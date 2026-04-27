-- Studio inbox/outbox renames.
--
-- Conventions (per CLAUDE.md "Verify gate" / "Output"):
--   PASS    : _output/verify-<slug>.md  ->  _input/pass-<slug>.md
--   FAIL    : _output/verify-<slug>.md  ->  _input/fail-<slug>.md
--   ANSWER  : _output/<slug>.md         ->  _input/<slug>.md   (non-verify)

local M = {}

local function dirname(path)
  return path:match("(.*)/[^/]+$")
end

-- Walk up from `path` until a dir contains both _output/ and _input/.
local function find_root(path)
  local dir = dirname(path)
  while dir and dir ~= "" and dir ~= "/" do
    if vim.fn.isdirectory(dir .. "/_output") == 1
      and vim.fn.isdirectory(dir .. "/_input") == 1 then
      return dir
    end
    dir = dirname(dir)
  end
  return nil
end

local function rename(root, from_rel, to_rel)
  local cmd = "cd " .. vim.fn.shellescape(root) .. " && " .. string.format(
    "mv -- %s %s 2>&1",
    vim.fn.shellescape(from_rel),
    vim.fn.shellescape(to_rel)
  )
  local out = vim.fn.system(cmd)
  if vim.v.shell_error == 0 then
    return true, "mv"
  end
  return false, out
end

-- If we're sitting in nvim-tree, the "current buffer" is the tree itself;
-- the file the user is pointing at is the node under the cursor.
local function tree_node_path()
  if vim.bo.filetype ~= "NvimTree" then return nil end
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then return nil end
  local node = api.tree.get_node_under_cursor()
  if not node or not node.absolute_path or node.type ~= "file" then return nil end
  return node.absolute_path
end

local function move_current(planner)
  local from_tree = tree_node_path()
  local bufnr = from_tree and -1 or vim.api.nvim_get_current_buf()
  local path = from_tree or vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    vim.notify("studio: buffer has no file", vim.log.levels.ERROR)
    return
  end
  path = vim.fn.fnamemodify(path, ":p")

  local root = find_root(path)
  if not root then
    vim.notify("studio: no _output/+_input/ pair above this file", vim.log.levels.ERROR)
    return
  end

  local rel = path:sub(#root + 2) -- strip "<root>/"
  local from_rel, to_rel, err = planner(rel)
  if err then
    vim.notify("studio: " .. err, vim.log.levels.ERROR)
    return
  end

  local to_abs = root .. "/" .. to_rel
  if vim.fn.filereadable(to_abs) == 1 then
    vim.notify("studio: target already exists: " .. to_rel, vim.log.levels.ERROR)
    return
  end

  if not from_tree and vim.bo[bufnr].modified then
    vim.cmd("silent write")
  end

  local ok, info = rename(root, from_rel, to_rel)
  if not ok then
    vim.notify("studio: rename failed:\n" .. info, vim.log.levels.ERROR)
    return
  end

  -- Find every buffer that points at the old path and every window showing one.
  local stale_bufs = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) == path then
      table.insert(stale_bufs, b)
    end
  end

  -- Swap each stale window over to the new file *before* wiping the old buffer,
  -- so the window never momentarily holds a deleted/empty buffer.
  local new_buf = vim.fn.bufadd(to_abs)
  vim.fn.bufload(new_buf)
  vim.bo[new_buf].buflisted = true
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    local wb = vim.api.nvim_win_get_buf(w)
    for _, sb in ipairs(stale_bufs) do
      if wb == sb then
        vim.api.nvim_win_set_buf(w, new_buf)
        break
      end
    end
  end

  -- Now safe to wipe the old buffers.
  for _, b in ipairs(stale_bufs) do
    pcall(vim.api.nvim_buf_delete, b, { force = false })
  end

  if from_tree then
    local ok_api, api = pcall(require, "nvim-tree.api")
    if ok_api then pcall(api.tree.reload) end
  elseif #stale_bufs == 0 then
    -- Fallback for the unlikely "no window was showing the old file" case.
    vim.cmd("edit " .. vim.fn.fnameescape(to_abs))
  end
  vim.notify(string.format("studio: %s  %s -> %s", info, from_rel, to_rel))
end

local function plan_verify(verdict)
  return function(rel)
    local slug = rel:match("^_output/verify%-(.+)%.md$")
    if not slug then
      return nil, nil, "not _output/verify-<slug>.md (got " .. rel .. ")"
    end
    return rel, "_input/" .. verdict .. "-" .. slug .. ".md"
  end
end

-- Generic _output/<slug>.md  ->  _input/<slug>.md  (refuses verify-*, those need pass/fail)
local function plan_to_input(rel)
  local name = rel:match("^_output/(.+%.md)$")
  if not name then
    return nil, nil, "not _output/<slug>.md (got " .. rel .. ")"
  end
  if name:match("^verify%-") then
    return nil, nil, "verify-* uses StudioPass/StudioFail"
  end
  return rel, "_input/" .. name
end

-- Generic _input/<slug>.md  ->  _output/<slug>.md  (refuses pass-/fail-, those use StudioVerify)
local function plan_to_output(rel)
  local name = rel:match("^_input/(.+%.md)$")
  if not name then
    return nil, nil, "not _input/<slug>.md (got " .. rel .. ")"
  end
  if name:match("^pass%-") or name:match("^fail%-") then
    return nil, nil, "{pass,fail}-* uses StudioVerify"
  end
  return rel, "_output/" .. name
end

-- Undo verdict: _input/pass-<slug>.md or _input/fail-<slug>.md  ->  _output/verify-<slug>.md
local function plan_verify_back(rel)
  local slug = rel:match("^_input/pass%-(.+)%.md$")
            or rel:match("^_input/fail%-(.+)%.md$")
  if not slug then
    return nil, nil, "not _input/pass-<slug>.md or _input/fail-<slug>.md (got " .. rel .. ")"
  end
  return rel, "_output/verify-" .. slug .. ".md"
end

function M.pass()       move_current(plan_verify("pass"))  end
function M.fail()       move_current(plan_verify("fail"))  end
function M.to_input()   move_current(plan_to_input)        end
function M.to_output()  move_current(plan_to_output)       end
function M.verify()     move_current(plan_verify_back)     end

-- Walk up from the current buffer (or cwd) to find a studio root.
local function locate_root()
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path ~= "" then
    local root = find_root(vim.fn.fnamemodify(buf_path, ":p"))
    if root then return root end
  end
  local cwd = vim.fn.getcwd()
  if vim.fn.isdirectory(cwd .. "/_output") == 1
    and vim.fn.isdirectory(cwd .. "/_input") == 1 then
    return cwd
  end
  return find_root(cwd .. "/.")
end

-- List verify-<slug>.md questions whose slug already has a pass-/fail- in the archive.
function M.resurfaced()
  local root = locate_root()
  if not root then
    vim.notify("studio: no _output/+_input/ pair found", vim.log.levels.ERROR)
    return
  end

  local lines = { "# Resurfaced verify tickets", "# root: " .. root, "" }
  local hits = 0
  local verify_files = vim.fn.glob(root .. "/_output/verify-*.md", false, true)
  table.sort(verify_files)
  for _, f in ipairs(verify_files) do
    local slug = vim.fn.fnamemodify(f, ":t"):match("^verify%-(.+)%.md$")
    if slug then
      local pat = string.format("%s/_input/archive/{pass,fail}-%s*.md", root, slug)
      local prior = vim.fn.glob(pat, false, true)
      if #prior > 0 then
        hits = hits + 1
        table.insert(lines, "_output/verify-" .. slug .. ".md")
        for _, p in ipairs(prior) do
          table.insert(lines, "  prior: _input/archive/" .. vim.fn.fnamemodify(p, ":t"))
        end
        table.insert(lines, "")
      end
    end
  end
  if hits == 0 then
    vim.notify("studio: no resurfaced verify tickets", vim.log.levels.INFO)
    return
  end
  table.insert(lines, 3, string.format("# %d slug(s) with prior verdict", hits))

  vim.cmd("botright new")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"
  vim.api.nvim_buf_set_name(buf, "studio://resurfaced")
end

vim.api.nvim_create_user_command("StudioPass",       M.pass,       { desc = "Studio: verify -> _input/pass-*" })
vim.api.nvim_create_user_command("StudioFail",       M.fail,       { desc = "Studio: verify -> _input/fail-*" })
vim.api.nvim_create_user_command("StudioInput",      M.to_input,   { desc = "Studio: _output/* -> _input/*" })
vim.api.nvim_create_user_command("StudioOutput",     M.to_output,  { desc = "Studio: _input/* -> _output/*" })
vim.api.nvim_create_user_command("StudioVerify",     M.verify,     { desc = "Studio: _input/{pass,fail}-* -> _output/verify-*" })
vim.api.nvim_create_user_command("StudioResurfaced", M.resurfaced, { desc = "Studio: list verify-* with prior pass-/fail- in archive" })

local map = vim.keymap.set
map("n", "<leader>sp", M.pass,       { desc = "studio: verify pass" })
map("n", "<leader>sf", M.fail,       { desc = "studio: verify fail" })
map("n", "<leader>si", M.to_input,   { desc = "studio: _output -> _input" })
map("n", "<leader>so", M.to_output,  { desc = "studio: _input -> _output" })
map("n", "<leader>sv", M.verify,     { desc = "studio: back to verify" })
map("n", "<leader>sr", M.resurfaced, { desc = "studio: resurfaced verify tickets" })

return M

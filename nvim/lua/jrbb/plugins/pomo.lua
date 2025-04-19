local Remap = require("jrbb.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<leader>ttb", ":TimerSession begin<cr>", { silent = true, desc = "Begin stream" })
nnoremap("<leader>ttt", ":TimerStart 5m Tea<cr>", { silent = true, desc = "5 min break" })
nnoremap("<leader>tts", ":TimerSession stop<cr>", { silent = true, desc = "Stop stream" })
nnoremap("<leader>ttc", ":TimerSession code<cr>", { silent = true, desc = "Code" })

nnoremap("<leader>th", ":TimerHide<cr>", { silent = true, desc = "Hide timer" })
nnoremap("<leader>ts", ":TimerShow<cr>", { silent = true, desc = "Show timer" })
nnoremap("<leader>tp", ":TimerPause<cr>", { silent = true, desc = "Pause timer" })
nnoremap("<leader>tr", ":TimerResume<cr>", { silent = true, desc = "Resume timer" })
nnoremap("<leader>te", ":TimerStop<cr>", { silent = true, desc = "Stop timer" })

local function format_time(time_left)
  if time_left <= 60 then
    return string.format("%ds", time_left)
  elseif time_left <= 300 then
    if math.fmod(time_left, 60) == 0 then
      return os.date("%Mm %Ss", time_left)
    else
      return os.date("%Mm %Ss", time_left)
    end
  elseif time_left < 3600 then
    return os.date("%Mm %Ss", time_left)
  else
    return os.date("%Hh %Mm %Ss", time_left)
  end
end

local CustomNotifier = {}

CustomNotifier.new = function(timer, opts)
  local self = setmetatable({}, { __index = CustomNotifier })
  self.timer = timer
  self.notification = nil
  self.opts = opts and opts or {}
  self.title_icon = self.opts.title_icon and self.opts.title_icon or "󱎫"
  self.text_icon = self.opts.text_icon and self.opts.text_icon or "󰄉"
  self.sticky = self.opts.sticky ~= false
  self._last_text = nil
  return self
end

CustomNotifier._update = function(self, text, level, timeout)
  local repetitions_str = ""
  if self.timer.max_repetitions ~= nil and self.timer.max_repetitions > 0 then
    repetitions_str = string.format(" [%d/%d]", self.timer.repetitions + 1, self.timer.max_repetitions)
  end

  local title
  if self.timer.name ~= nil then
    title = string.format(
      "%s %s",
      self.timer.name,
      repetitions_str
    )
  else
    title = string.format(
      "Timer #%d %s",
      self.timer.id,
      repetitions_str
    )
  end

  if text ~= nil then
    self._last_text = text
  elseif not self._last_text then
    return
  else
    text = self._last_text
  end

  assert(text)

  local ok, notify = pcall(require, "notify")
  if not ok then
    notify = vim.notify
  end

  local notification = notify(text, level, {
    icon = self.title_icon,
    title = title,
    timeout = timeout,
    replace = self.notification,
    hide_from_history = true,
  })

  if self.sticky then
    self.notification = notification
  else
    self.notification = nil
  end
end

CustomNotifier.tick = function(self, time_left)
  if self.sticky then
    self:_update(
      string.format(
        " %s  %s left...%s",
        self.text_icon,
        format_time(time_left),
        self.timer.paused and " (paused)" or ""
      ),
      vim.log.levels.INFO,
      false
    )
  end
end

CustomNotifier.start = function(self)
  self:_update(string.format(" %s  starting...", self.text_icon), vim.log.levels.INFO, false)
end

CustomNotifier.done = function(self)
  self:_update(string.format(" %s  timer done!", self.text_icon), vim.log.levels.WARN, 3000)
end

CustomNotifier.stop = function(self)
  self:_update(string.format(" %s  stopping...", self.text_icon), vim.log.levels.INFO, 1000)
end

CustomNotifier.hide = function(self)
  self.sticky = false
  self:_update(nil, vim.log.levels.INFO, 100)
end

CustomNotifier.show = function(self)
  self.sticky = true
  local time_left = self.timer:time_remaining()
  if time_left ~= nil and time_left > 0 then
    self:tick(time_left)
  end
end

return {
  "RobertBrewitz/pomo.nvim",
  branch = "main",
  lazy = true,
  cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
  dependencies = {
    "rcarriga/nvim-notify",
  },
  opts = {
    update_interval = 1000,
    background_color = "#000000",
    notifiers = {
      {
        init = CustomNotifier.new,
        opts = {
          sticky = true,
          title_icon = "󱎫",
          text_icon = "󰄉",
        },
      },
    },
    sessions = {
      begin = {
        { name = "Starting soon, next up: Chat & Plan", duration = "5m" },
        { name = "Chatting & Planning, next up: Break", duration = "25m" },
        { name = "Break, next up: Chat & Plan", duration = "5m" },
        { name = "Chatting & Planning", duration = "25m" },
      },
      code = {
        { name = "Code", duration = "25m" },
        { name = "Break", duration = "5m" },
      },
      stop = {
        { name = "Ending the stream", duration = "20m" },
      },
    },
  },
  config = function(_, opts)
    require("pomo").setup(opts)
    require("notify").setup({
      background_colour = opts.background_color,
    })

  end,
}

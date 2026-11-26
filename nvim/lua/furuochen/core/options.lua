vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab
opt.autoindent = true -- copies indent

opt.wrap = false

-- Softwrap only: statuscolumn uses screen-line relative numbers (matches gj/gk).
-- When wrap is off, empty statuscolumn → normal number/relativenumber.
-- Return statusline text with highlights (`%{%…%}`) so only the cursor's
-- screen row uses CursorLineNr; other wrapped rows of the same paragraph stay LineNr.
_G.visual_relnum = function()
  -- Skip filler / virtual overlay rows.
  if vim.v.virtnum < 0 then
    return ""
  end

  local cur_line = vim.fn.line(".")
  local cur_screen = vim.fn.screenpos(0, cur_line, vim.fn.col(".")).row
  -- screenpos(..., 1) is the first screen row of the logical line; +virtnum
  -- walks down wrapped segments of that same paragraph.
  local target_screen = vim.fn.screenpos(0, vim.v.lnum, 1).row + vim.v.virtnum

  if cur_screen == 0 or target_screen == 0 then
    return "%#LineNr#" .. tostring(vim.v.relnum) .. " "
  end

  if cur_screen == target_screen then
    return "%#CursorLineNr#" .. tostring(vim.v.lnum) .. " "
  end

  return "%#LineNr#" .. tostring(math.abs(cur_screen - target_screen)) .. " "
end

local function sync_wrap_statuscolumn()
  if vim.wo.wrap then
    -- `{% %}` re-evaluates returned %#…# as statusline syntax.
    vim.wo.statuscolumn = "%=%{%v:lua.visual_relnum()%}"
    -- Highlight only the cursor screen row, not the whole wrapped paragraph.
    vim.wo.cursorlineopt = "screenline,number"
  else
    vim.wo.statuscolumn = ""
    vim.wo.cursorlineopt = "line,number"
  end
end

-- Moving with gj/gk stays on the same lnum, so Neovim won't refresh other
-- statuscolumn cells unless we force a redraw.
local function refresh_wrap_statuscolumn()
  if not vim.wo.wrap then
    return
  end
  vim.wo.statuscolumn = vim.wo.statuscolumn
end

vim.api.nvim_create_autocmd("OptionSet", {
  pattern = "wrap",
  callback = sync_wrap_statuscolumn,
})
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = sync_wrap_statuscolumn,
})
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled" }, {
  callback = refresh_wrap_statuscolumn,
})

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- case sensitive when input mixed

opt.cursorline = true

-- colors
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start" -- backspace on indent, EOL, insert mode start pos

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

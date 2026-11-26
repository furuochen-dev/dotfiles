-- Chinese word motions (w/b/e/ge) via jieba-lua.
-- Critical: wordmotion needs starwing luautf8 (`utf8.next`). Do NOT put
-- packages/lua-utf8 on rtp — that pure-Lua stub breaks cut() and w/b/e.
return {
  "neo451/jieba-lua",
  lazy = false,
  build = false,
  init = function()
    local root = vim.fn.stdpath("data") .. "/lazy/jieba-lua"
    local rocks = vim.fn.stdpath("data") .. "/lazy-rocks/jieba-lua"
    if vim.fn.isdirectory(root) == 0 then
      return
    end

    if vim.fn.isdirectory(rocks .. "/lib/lua/5.1") == 1 then
      package.cpath = rocks .. "/lib/lua/5.1/?.so;" .. package.cpath
    end

    -- Prefer repo Lua for jieba + wordmotion over any luarocks lua copies.
    package.path = table.concat({
      root .. "/lua/?.lua",
      root .. "/lua/?/init.lua",
      root .. "/packages/wordmotion.nvim/lua/?.lua",
      root .. "/packages/wordmotion.nvim/lua/?/init.lua",
      package.path,
    }, ";")

    vim.opt.rtp:prepend(root .. "/packages/wordmotion.nvim")

    if not package.loaded.lpeg then
      package.preload.lpeg = function()
        return vim.lpeg
      end
    end

    -- Ensure utf8 is the C library with utf8.next (reload if a stub won the race).
    local function load_utf8()
      package.loaded.utf8 = nil
      package.preload.utf8 = nil
      local ok, mod = pcall(require, "utf8")
      if ok and type(mod.next) == "function" then
        return mod
      end
      package.loaded.utf8 = nil
      ok, mod = pcall(require, "lua-utf8")
      if ok then
        package.loaded.utf8 = mod
        return mod
      end
      return nil
    end
    if not load_utf8() then
      vim.schedule(function()
        vim.notify(
          "jieba-lua: need luautf8 (utf8.next). Try: luarocks --tree ~/.local/share/nvim/lazy-rocks/jieba-lua install luautf8",
          vim.log.levels.WARN
        )
      end)
    end
  end,
  config = function()
    local ok, mod = pcall(require, "wordmotion.nvim.jieba")
    if not ok then
      vim.notify("jieba-lua failed: " .. tostring(mod), vim.log.levels.WARN)
      return
    end
    mod.init()
    mod.set_keymaps()
  end,
}

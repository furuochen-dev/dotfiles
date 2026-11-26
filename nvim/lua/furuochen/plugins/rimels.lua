return {
  "liubianshi/cmp-lsp-rimels",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",
  },
  keys = {
    { ";f", mode = "i", desc = "Start rime-ls" },
  },
  config = function()
    local host, port = "127.0.0.1", 9257
    local bin = vim.fn.expand("~/.local/bin/rime_ls")
    if vim.fn.executable(bin) == 0 then
      bin = "rime_ls"
    end

    -- One shared rime_ls process so multiple nvim instances do not lock the DB.
    local listening = (vim.fn.system({ "nc", "-z", host, tostring(port) }) and vim.v.shell_error == 0)
    if not listening then
      vim.system({ bin, "--listen", string.format("%s:%d", host, port) }, { detach = true })
      vim.wait(800, function()
        vim.fn.system({ "nc", "-z", host, tostring(port) })
        return vim.v.shell_error == 0
      end)
    end

    -- Patch before rimels loads cmp_keymaps: defaults omit () so fullwidth
    -- brackets never auto-confirm the way ，。！？ do.
    local defaults = require("rimels.default_opts")
    for _, sym in ipairs({ "(", ")", "[", "]", "{", "}" }) do
      if not vim.tbl_contains(defaults.punctuation_upload_directly, sym) then
        table.insert(defaults.punctuation_upload_directly, sym)
      end
    end

    require("rimels").setup({
      cmd = vim.lsp.rpc.connect(host, port),
      rime_user_dir = vim.fn.expand("~/Library/Rime"),
      shared_data_dir = "/Library/Input Methods/Squirrel.app/Contents/SharedSupport",
      keys = { start = ";f", stop = ";;", esc = ";j", undo = ";u" },
      -- Fewer redraws while composing; menu still updates, just less thrash.
      max_candidates = 5,
      always_incomplete = false,
    })

    -- Smear animates every cmp redraw; pause it while rime is on.
    local function sync_smear()
      local ok_smear, smear = pcall(require, "smear_cursor")
      local ok_utils, utils = pcall(require, "rimels.utils")
      if not ok_smear or smear.enabled == nil then
        return
      end
      local rime_on = ok_utils and (utils.global_rime_enabled() or utils.buf_rime_enabled())
      smear.enabled = not rime_on
    end
    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CursorMovedI" }, {
      callback = sync_smear,
    })
  end,
}

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    {
     'oppara/nvim-tree-preview.lua',
      version = false,
      dependencies = {
        'nvim-lua/plenary.nvim',
        '3rd/image.nvim', -- Optional, for previewing images
      },
    }
  },
  config = function()
    local nvimtree = require("nvim-tree")

    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.opt.termguicolors = true

    local function open_win_config_func()
        local scr_w = vim.opt.columns:get()
        local scr_h = vim.opt.lines:get()
        local tree_w = 80
        local tree_h = math.floor(tree_w * scr_h / scr_w)
        return {
          border = "double",
          relative = "editor",
          width = tree_w,
          height = tree_h,
          col = (scr_w - tree_w) / 2,
          row = (scr_h - tree_h) / 2
        }
    end

    nvimtree.setup({
      view = {
        signcolumn = "yes",
        float = {
             enable = true,
             open_win_config = open_win_config_func
        },
        cursorline = false,
        width = 35,
        relativenumber = true,
      },
      -- change folder arrow icons
      renderer = {
        indent_markers = {
          enable = true,
        },
        icons = {
          git_placement = "after",
          show = {
            folder_arrow = false
          },
          glyphs = {
            git = {
              staged = "w",
              unstaged = "w",
              deleted = "-",
              untracked = "",
              renamed = "",
              ignored = "i"
            },
          },
        },
      },
      -- disable window_picker for
      -- explorer to work well with
      -- window splits
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
          quit_on_open = true,
        },
      },
      filters = {
        custom = { ".DS_Store", ".git" },
      },
      git = {
        ignore = false,
      },
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        -- Important: When you supply an `on_attach` function, nvim-tree won't
        -- automatically set up the default keymaps. To set up the default keymaps,
        -- call the `default_on_attach` function. See `:help nvim-tree-quickstart-custom-mappings`.
        api.config.mappings.default_on_attach(bufnr)

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        local function edit_or_open()
          local node = api.tree.get_node_under_cursor()

          if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
          else
            -- open file
            api.node.open.edit()
            -- Close the tree if file was opened
            api.tree.close()
          end
        end

        -- open as vsplit on current node
        local function vsplit_preview()
          local node = api.tree.get_node_under_cursor()

          if node.nodes ~= nil then
            -- expand or collapse folder
            api.node.open.edit()
          else
            -- open file as vsplit
            api.node.open.vertical()
          end

          -- Finally refocus on tree if it was lost
          api.tree.focus()
        end
        local preview = require('nvim-tree-preview')

        vim.keymap.set('n', 'P', preview.watch, opts 'Preview (Watch)')
        vim.keymap.set('n', '<Esc>', preview.unwatch, opts 'Close Preview/Unwatch')
        vim.keymap.set('n', '<C-j>', function() return preview.scroll(4) end, opts 'Scroll Down')
        vim.keymap.set('n', '<C-k>', function() return preview.scroll(-4) end, opts 'Scroll Up')

        vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
        vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
        vim.keymap.set("n", "h", api.node.navigate.parent, opts("Close"))
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
        -- Option A: Smart tab behavior: Only preview files, expand/collapse directories (recommended)
        vim.keymap.set('n', '<Tab>', function()
          local ok, node = pcall(api.tree.get_node_under_cursor)
          if ok and node then
            if node.type == 'directory' then
              api.node.open.edit()
            else
              preview.node(node, { toggle_focus = true })
            end
          end
        end, opts 'Preview')
        function find_directory_and_focus()
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          local function open_nvim_tree(prompt_bufnr, _)
            actions.select_default:replace(function()
              local api = require("nvim-tree.api")

              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              api.tree.open()
              api.tree.find_file(selection.cwd .. "/" .. selection.value)
            end)
            return true
          end

          require("telescope.builtin").find_files({
            find_command = { "fd", "--type", "directory", "--hidden", "--exclude", ".git/*" },
            attach_mappings = open_nvim_tree,
          })
        end

        vim.keymap.set("n", "fd", find_directory_and_focus)
        vim.keymap.set('n', '<Esc>', api.tree.close, opts('Close'))
      end,
    })

    -- set keymaps
    local keymap = vim
        .keymap                                                                                                         -- for conciseness

    keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })                         -- toggle file explorer
    keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
    keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })                     -- collapse file explorer
    keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })                       -- refresh file explorer
  end
}

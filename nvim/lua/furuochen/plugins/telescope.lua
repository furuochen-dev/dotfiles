return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local function open_in_nvim_tree(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        -- selection.path is the directory path
        if selection then

            if vim.fn.isdirectory(selection.path) ~= 0 then
              require("nvim-tree.api").tree.find_file({ 
                buf = selection.path,
                focus = true,
                open = true
              })
            else
              vim.cmd("edit " .. selection.path)
            end

         end
    end

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<esc>"] = actions.close,
            ["<cr>"] = open_in_nvim_tree
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    local builtin = require("telescope.builtin")

    -- Custom function to find directories
    local find_directories = function()
      builtin.find_files({
        prompt_title = "Find Directories",
        find_command = { "fd", "--type", "d", "--strip-cwd-prefix", "--exclude", ".."},
      })
    end

    -- Keymap example
    keymap.set("n", "<leader>fd", find_directories, { desc = "Find Directories" })

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fg", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", { desc = "Find symbols" })
  end,
}

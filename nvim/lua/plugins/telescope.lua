return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  -- or                              , branch = '0.1.x',
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require('telescope').setup {
      defaults = {
        file_ignore_patterns = { ".bak" },
      }
    }
    local builtin = require('telescope.builtin')
    -- file finder
    vim.keymap.set('n', '<leader>f', "<Nop>", { desc = 'Telescope' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fc', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fh', function() builtin.find_files({ cwd = os.getenv("HOME") }) end,
      { desc = 'Find in home' })
    vim.keymap.set('n', '<leader>fo', function() builtin.find_files({ cwd = "~/sync/vault" }) end,
      { desc = 'Find in vault' })
    vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = 'Git files' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Marks' })
    vim.keymap.set('n', '<leader>fj', builtin.jumplist, { desc = 'Jumplist' })
    -- TODO: fi - add file to ignore list
    -- TODO: fp - view and edit ignore pattern

    -- live grep
    vim.keymap.set('n', '<leader>g', "<Nop>", { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>gh', function() builtin.live_grep({ cwd = os.getenv("HOME") }) end, { desc = 'Home' })
    vim.keymap.set('n', '<leader>gc', builtin.live_grep, { desc = 'Cwd' })
    vim.keymap.set('n', '<leader>gg', function()
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
      if git_root and git_root ~= "" then
        builtin.live_grep({ cwd = git_root })
      else
        print("Not inside a Git repository")
      end
    end, { desc = 'Live grep in Git-tracked files' })

    local function get_open_buffers()
      local buffers = vim.api.nvim_list_bufs()
      local paths = {}
      for _, buf in ipairs(buffers) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
          local path = vim.api.nvim_buf_get_name(buf)
          if path ~= "" then
            table.insert(paths, path)
          end
        end
      end
      return paths
    end
    vim.keymap.set('n', '<leader>gb', function()
      builtin.live_grep({ search_dirs = get_open_buffers() })
    end, { desc = 'Live grep in open buffers' })

    -- TreeSitter
    -- Check out: https://github.com/stevearc/aerial.nvim
    vim.keymap.set("n", "<Leader>gf", function()
      builtin.lsp_document_symbols({
        symbols = { "Function", "Method" }, -- you can list multiple kinds here
      })
    end, { desc = "List functions in document" })
    vim.keymap.set("n", "<Leader>gl", function()
      builtin.lsp_document_symbols({
        symbols = { "Loop" }, -- you can list multiple kinds here
      })
    end, { desc = "List functions in document" })
    vim.keymap.set("n", "<Leader>gi", function()
      builtin.lsp_document_symbols({
        symbols = { "If", "Conditional" }, -- you can list multiple kinds here
      })
    end, { desc = "List functions in document" })
  end,
}

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      local ok, ufo = pcall(require, "ufo")
      if not ok then
        vim.notify("Failed to load nvim-ufo", vim.log.levels.WARN)
        return
      end

      -- Fold settings
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_ufo#foldexpr()"
      vim.o.foldtext = "" -- Use ufo's handler instead

      -- Fold text display customization
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d lines "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
            curWidth = curWidth + chunkWidth
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            break
          end
        end

        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      local function fold()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local indent = vim.fn.indent(".")
        if col <= indent then
          vim.cmd("silent! foldclose")
        else
          vim.api.nvim_feedkeys("h", "n", false)
        end
      end

      local function foldAll()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local indent = vim.fn.indent(".")
        if col <= indent then
          -- TODO: Fold the current line, but also fold all the sub folds that are in the fold that is on the current line. Sounds confusing.
          vim.print("TODO")
        else
          vim.api.nvim_feedkeys("^", "n", false)
        end
      end

      local function unfold()
        local lnum = vim.api.nvim_win_get_cursor(0)[1]
        if vim.fn.foldclosed(lnum) ~= -1 then
          vim.cmd("silent! foldopen")
        else
          vim.api.nvim_feedkeys("l", "n", false)
        end
      end

      local function unfoldAll()
        local lnum = vim.api.nvim_win_get_cursor(0)[1]
        if vim.fn.foldclosed(lnum) ~= -1 then
          vim.cmd("silent! foldopen!")
        else
          vim.api.nvim_feedkeys("$", "n", false)
        end
      end
      -- Keymaps
      vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds (UFO)" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds (UFO)" })
      vim.keymap.set("n", "h", fold, { desc = "Smart fold (left)" })
      vim.keymap.set("n", "gh", foldAll, { desc = "Smart fold (left)" })
      vim.keymap.set("n", "l", unfold, { desc = "Smart unfold (right)" })
      vim.keymap.set("n", "gl", unfoldAll, { desc = "Smart unfold (right)" })
      vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor, { desc = "Peek (preview) fold" })
      vim.keymap.set("n", "nz", ufo.goNextClosedFold, {desc = "Next closed fold (UFO)"})
      vim.keymap.set("n", "Nz", ufo.goPreviousClosedFold, {desc = "Next closed fold (UFO)"})

      -- Setup ufo
      ufo.setup({
        provider_selector = function(_, filetype, _)
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
      })
    end,
  },
}

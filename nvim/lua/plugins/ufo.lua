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
        if col > indent then
          vim.api.nvim_feedkeys("^", "n", false)
        else
          local ufo = require("ufo")
          local bufnr = vim.api.nvim_get_current_buf()
          local cursorLine = vim.api.nvim_win_get_cursor(0)[1]

          local folds = ufo.getFolds(bufnr, "treesitter")
          if not folds then
            vim.notify("No folds returned by UFO", vim.log.levels.WARN)
            return
          end

          -- Find the fold under the cursor
          local function findRootFold(folds, cursorLine)
            -- Gets the fold under the cursor
            local foldLevelCursor = vim.fn.foldlevel(cursorLine)
            for _, fold in ipairs(folds) do
              local startLine = fold.startLine
              local endLine = fold.endLine
              if cursorLine >= (startLine + 1) and cursorLine <= (endLine + 1) then
                if vim.fn.foldlevel(startLine + 1) == foldLevelCursor then
                  return {
                    startLine = startLine,
                    endLine = endLine
                  }
                end
              end
            end
            return nil
          end

          local function findNestedFolds(folds, rootFold)
            local nested = {}
            for _, fold in ipairs(folds) do
              local startLine = fold.startLine
              local endLine = fold.endLine
              if startLine > rootFold.startLine and endLine < rootFold.endLine then
                table.insert(nested, {
                  startLine = startLine,
                  endLine = endLine
                })
              end
            end

            local function remove_duplicates_by_lines(arr)
              local seen = {}
              local result = {}

              for _, value in ipairs(arr) do
                local key = value.startLine .. ":" .. value.endLine
                if not seen[key] then
                  table.insert(result, value)
                  seen[key] = true
                end
              end

              return result
            end

            nested = remove_duplicates_by_lines(nested)
            table.sort(nested, function(a, b)
              return a.startLine > b.startLine
            end)
            return nested
          end

          local rootFold = findRootFold(folds, cursorLine)
          if rootFold == nil then
            vim.notify("No fold under cursor", vim.log.levels.INFO)
            return
          end

          local nestedFolds = findNestedFolds(folds, rootFold)

          local cmd = ""
          for _, fold in ipairs(nestedFolds) do
            if vim.fn.foldclosed(fold.startLine + 1) == -1 then
              cmd = (fold.startLine + 1) .. "foldclose"
              vim.cmd(cmd)
            end
          end

          cmd = (rootFold.startLine + 1) .. "foldclose"
          vim.cmd(cmd)
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
      -- vim.keymap.set("n", "zp", ufo.peekFoldedLinesUnderCursor, { desc = "Peek (preview) fold" })
      vim.keymap.set("n", "zp", function()
        local lnum = vim.api.nvim_win_get_cursor(0)[1]
        if vim.fn.foldclosed(lnum) ~= -1 then
          ufo.peekFoldedLinesUnderCursor()
          vim.cmd("wincmd w") -- switch window
        end
      end, { desc = "Peek (preview) fold" })
      vim.keymap.set("n", "nz", ufo.goNextClosedFold, { desc = "Next closed fold (UFO)" })
      vim.keymap.set("n", "Nz", ufo.goPreviousClosedFold, { desc = "Next closed fold (UFO)" })

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

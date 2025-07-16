-- Lazy
require("config.lazy")

-- Config
require("config.appearance")
require("config.keymaps")
require("config.latex")
require("config.markdown")
require("config.other")
require("config.python")
require("config.snippets")
require("config.terminal")

if vim.g.neovide then
  require("config.neovide") -- ✅
end

-- My plugins
require("myPlugins.bufferClosing")                   -- ✅
require("myPlugins.community")                       -- ✅
require("myPlugins.floatingDiary")                   -- ✅
require("myPlugins.homepage")                        -- ✅
require("myPlugins.projectManager")                  -- ✅
require("myPlugins.quickToggle")                     -- ✅
require("myPlugins.reopenBuffer")                    -- ✅
require("myPlugins.todoList")                        -- ❌
SessionManager = require("myPlugins.sessionManager") -- ✅

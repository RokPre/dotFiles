-- Lazy
require("config.lazy")
-- ~/sync/dotFiles/nvim/lua/config/pluginlist.lua

-- My plugins
require("myPlugins.bufferClosing")                   -- ✅
require("myPlugins.community")                       -- ❌
require("myPlugins.floatingDiary")                   -- ✅
require("myPlugins.homepage")                        -- ❌
require("myPlugins.linking")                         -- ✅
require("myPlugins.projectManager")                  -- ❌
require("myPlugins.quickToggle")                     -- ✅
require("myPlugins.reopenBuffer")                    -- ✅
require("myPlugins.todoList")                        -- ❌
SessionManager = require("myPlugins.sessionManager") -- ✅

-- Config
require("config.appearance") -- TODO: Move these into here.
require("config.keymaps")
require("config.latex")
require("config.markdown")
require("config.other")
require("config.python")
require("config.snippets")
require("config.terminal")

if vim.g.neovide then
  require("config.neovide")
end

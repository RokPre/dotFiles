-- Plugins
require("config.lazy")

-- require("config.appearance")
require("config.appearance")
require("config.keymaps")
require("config.latex")
require("config.lazy")
require("config.markdown")
require("config.neovide")
require("config.other")
require("config.python")
require("config.snippets")
require("config.terminal")

-- My "plugins"
require("myPlugins.community")
-- require("myPlugins.debug")
require("myPlugins.diaryMode")
require("myPlugins.floatingDiary")
require("myPlugins.focusMode")
require("myPlugins.projectManager")
require("myPlugins.reopenBuffer")
require("myPlugins.todoList")
require("myPlugins.bufferClosing")
SessionManager = require("myPlugins.sessionManager")

if vim.g.neovide then
  require("config.neovide")
end

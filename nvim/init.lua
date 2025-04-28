-- Plugins
require("config.lazy")
require("config.pluginlist")

require("config.keymaps")
require("config.lazy")
require("config.markdown")
require("config.neovide")
require("config.other")
require("config.terminal")
require("config.theme")
require("config.python")

-- My "plugins"
require("myPlugins.debug")
require("myPlugins.diaryMode")
require("myPlugins.fileFinder")
require("myPlugins.focusMode")
require("myPlugins.liveGrep")
require("myPlugins.projectManager")
require("myPlugins.reopenBuffer")
require("myPlugins.todoList")
SessionManager = require("myPlugins.sessionManager")

if vim.g.neovide then
	require("config.neovide")
end

vim.g.netrw_browsex_viewer = "nvim" -- Change this to another editor if needed

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
require("debug.lua")
require("diaryMode.lua")
require("fileFinder.lua")
require("focusMode.lua")
require("liveGrep.lua")
require("projectManager.lua")
require("reopenBuffer.lua")
require("todoList.lua")
SessionManager = require("myPlugins.sessionManager")

if vim.g.neovide then
	require("config.neovide")
end

vim.g.netrw_browsex_viewer = "nvim" -- Change this to another editor if needed

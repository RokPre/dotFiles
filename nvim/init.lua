-- Plugins
require("config.lazy")

require("config.keymaps")
require("config.latex")
require("config.lazy")
require("config.markdown")
require("config.messages")
require("config.neovide")
require("config.python")
require("config.other")
require("config.terminal")
require("config.theme")

-- My "plugins"
require("myPlugins.debug")
require("myPlugins.diaryMode")
require("myPlugins.focusMode")
require("myPlugins.projectManager")
require("myPlugins.reopenBuffer")
require("myPlugins.todoList")
SessionManager = require("myPlugins.sessionManager")

if vim.g.neovide then
	require("config.neovide")
end

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

-- My "plugins"
require("myPlugins.diaryMode")
require("myPlugins.focusMode")
require("myPlugins.reopenBuffer")
require("myPlugins.projectManager")
require("myPlugins.todoList")

if vim.g.neovide then
	require("config.neovide")
end

vim.g.netrw_browsex_viewer = "nvim" -- Change this to another editor if needed

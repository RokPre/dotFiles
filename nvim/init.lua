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

if vim.g.neovide then
	require("config.neovide")
end

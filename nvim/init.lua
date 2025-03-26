require("config.lazy")
require("config.theme")
require("config.keymaps")
require("config.other")
require("config.commands")
require("config.autoCMD")

-- My "plugins"
require("plugins.diaryMode")
require("plugins.focusMode")
require("plugins.history")

if vim.g.neovide then
	require("config.neovide")
end

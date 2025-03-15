require("config.lazy")
require("config.theme")
require("config.keymaps")
require("config.other")
require("config.commands")
require("config.autoCMD")
require("plugins.diaryMode")

if vim.g.neovide then
	require("config.neovide")
end

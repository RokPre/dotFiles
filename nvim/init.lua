require("config.lazy")
require("config.theme")
require("config.keymaps")
require("config.other")
require("config.autoCMD")

if vim.g.neovide then
	require("config.neovide")
end

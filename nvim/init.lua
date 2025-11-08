-- Lazy
require("config.lazy") -- lua/config/lazy.lua

-- My plugins
require("myPlugins.homepage") -- ✅
require("myPlugins.linking") -- ✅
require("myPlugins.projectManager") -- ✅
require("myPlugins.quickToggle") -- ✅
require("myPlugins.reopenBuffer") -- ✅
require("myPlugins.todoList") -- ❌
require("myPlugins.sessionManager") -- ✅

-- Config
require("config.appearance")
require("config.keymaps")
require("config.latex")
require("config.markdown")
require("config.other")
require("config.snippets")
require("config.terminal")

if vim.g.neovide then
	require("config.neovide")
end

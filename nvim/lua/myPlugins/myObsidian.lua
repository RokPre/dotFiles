-- TODO: Paste image
-- TODO: link to notes using markdown notation. (linking.lua)
-- TODO: Rename file (update all the links)
-- TODO: Show backlinks
-- TODO: Templates
-- TODO: Embed excalidraw
-- TODO: Obsidian daily note
-- TODO: Tags
-- TODO: Add notes to cmp, and their aliases

local builtin = require("telescope.builtin")
local notes_folder = "~/sync/knowledgeVault/"

vim.keymap.set("n", "<leader>ns", function()
	builtin.find_files({ cwd = notes_folder })
end, {})

vim.keymap.set("n", "<leader>ng", function()
	builtin.live_grep({ cwd = notes_folder })
end, {})

vim.keymap.set("n", "<leader>nl", function()
	builtin.find_files({ cwd = notes_folder })
end, {})

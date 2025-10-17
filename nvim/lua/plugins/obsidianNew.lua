local home = os.getenv("HOME")
local vaultName = "knowledgeVault"
local vaultPath = home .. "/sync/" .. vaultName
local excalidraw_folder = "Excalidraw/"
local uv = vim.loop

vim.keymap.set("n", "<Leader>o", "<Nop>", { noremap = true, silent = true, desc = "Obsidian" })
vim.keymap.set("n", "<Leader>on", "<Cmd>Obsidian new<CR>", { noremap = true, silent = true, desc = "New Note" })
vim.keymap.set(
	"n",
	"<Leader>oo",
	"<Cmd>Obsidian search<CR>",
	{ noremap = true, silent = true, desc = "Obsidian serach" }
)
vim.keymap.set(
	"n",
	"<Leader>oO",
	"<Cmd>Obsidian open<CR>",
	{ noremap = true, silent = true, desc = "Open in Obsidian" }
)
vim.keymap.set("n", "<Leader>or", "<Cmd>Obsidian rename<Cr>", { noremap = true, silent = true, desc = "Rename Note" })
vim.keymap.set(
	"n",
	"<Leader>ob",
	"<Cmd>Obsidian backlinks<Cr>",
	{ noremap = true, silent = true, desc = "Show backlinks" }
)
vim.keymap.set("n", "<Leader>ot", "<Cmd>Obsidian template<Cr>", { noremap = true, silent = true, desc = "Template" })
vim.keymap.set(
	"n",
	"<Leader>oi",
	"<Cmd>Obsidian paste_img<Cr>",
	{ noremap = true, silent = true, desc = "Paste image" }
)

local function OpenExcalidraw()
	-- Check is obisidian is open
	local result = vim.fn.systemlist("pgrep -x obsidian")
	local defer = 0
	if #result == 0 then
		local uri = string.format("obsidian://open?vault=%s", vaultName)
		vim.fn.jobstart({ "xdg-open", uri }, { detach = true })
		defer = 2000
	end

	local buffer_name = vim.api.nvim_buf_get_name(0)
	local filename = vim.fn.fnamemodify(buffer_name, ":t:r")
	local sketch_name = filename .. "_" .. os.date("%Y-%m-%d-%H-%M-%S") .. ".excalidraw.md"
	local sketch_image = sketch_name:gsub(".md", ".svg")
	local sketch_path = "Attachment%20folder%2FExcalidraw%2F" .. sketch_name

	local content = [[---

excalidraw-plugin: parsed
tags: [excalidraw]

---
%23%23 Drawing
```compressed-json
N4IgLgngDgpiBcIYA8DGBDANgSwCYCd0B3EAGhADcZ8BnbAewDsEAmcm+gV31TkQAswYKDXgB6MQHNsYfpwBGAOlT0AtmIBeNCtlQbs6RmPry6uA4wC0KDDgLFLUTJ2lH8MTDHQ0YNMWHRJMRZFAEYAVjCyJE9VGEYwGgQAbQBdcnQoKABlALA+UFkYOIQQXHR8AGtoyXw8bOwNPkZOTExyHRgiACF0VErarkZcAGF6THp8UoBiADN5hZAAXyWgA
```
%25%25
]]

	local uri_new = string.format("obsidian://new?vault=%s&file=%s&content=%s", vaultName, sketch_path, content)

	local uri_open = string.format("obsidian://open?vault=%s&file=%s", vaultName, sketch_path)

	-- Open Obsidian
	vim.defer_fn(function()
		vim.fn.jobstart({ "xdg-open", uri_new }, { detach = true })
		vim.defer_fn(function()
			vim.fn.jobstart({ "xdg-open", uri_open }, { detach = true })
		end, 2000)
	end, defer)
	-- Insert embed link into current note
	local link = string.format("![image](%s%s)", excalidraw_folder, sketch_image)
	vim.api.nvim_put({ link }, "l", true, true)
end

vim.keymap.set("n", "<Leader>oe", OpenExcalidraw, { noremap = true, silent = true, desc = "Embed excalidraw" })

return {
	"obsidian-nvim/obsidian.nvim",
	cond = function()
		local stat = uv.fs_stat(vaultPath)
		return stat and stat.type == "directory"
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				-- name = "vault",
				name = "vault",
				path = vaultPath,
			},
		},
		preferred_link_style = "markdown",

		legacy_commands = false,
		frontmatter = { enabled = false },
		templates = {
			folder = "template",
			date_format = "%Y - %j",
			time_format = "%H:%M",
			substitutions = {
				today = function()
					return os.date("%Y %B %d - %A")
				end,
				yesterday = function()
					return os.date("%Y - %j", os.time() - 86400)
				end,
				tomorrow = function()
					return os.date("%Y - %j", os.time() + 86400)
				end,
				day = function()
					return os.date("%A")
				end,
				id = function()
					return os.time(os.date("!*t")) -- not unix timestamp
				end,
			},
		},
		daily_notes = {
			folder = "Dnevnik",
			date_format = "%Y - %j",
			template = "Neovim-DailyNote-template.md",
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		ui = {
			enable = false,
		},
		attachments = {
			folder = "Attachment folder",
			img_folder = "Attachment folder",
			img_text_func = function(path)
				vim.print("HERE")
				local name = vim.fs.basename(tostring(path)) -- e.g. "my_image.png"
				local encoded_name = require("obsidian.util").urlencode(name)
				return string.format("![image](%s)", encoded_name)
			end,
		},
	},
}

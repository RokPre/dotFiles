local cache = {
	["/home/lasim/file.py"] = {
		mtime = 1650002000,
		todos = { line = 12, column = 1, text = "do X" },
	},
	["/home/lasim/file1.py"] = {
		mtime = 1650002000,
		todos = { line = 12, column = 1, text = "do X" },
	},
}

local path = "/home/lasim/git_repo"
vim.print(cache[path])
vim.print(cache[path]["mtime"])
vim.print(cache[path]["todos"])
vim.print(cache[path]["todos"]["text"])
vim.print(cache[path]["todos"]["text"])
